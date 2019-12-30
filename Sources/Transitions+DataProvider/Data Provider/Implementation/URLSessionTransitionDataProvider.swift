import Foundation

public class URLSessionTransitionDataProvider: NSObject, TransitionDataProvider {

  let configuration: URLSessionConfiguration
  var session: URLSession!

  private let operationQueue: OperationQueue
  private var taskRegister = [Int: URLDataProviderTask]()
  private let taskRegisterSemaphore = DispatchSemaphore(value: 1)

  public init(configuration: URLSessionConfiguration, operationQueue: OperationQueue) {
    self.configuration = configuration
    self.operationQueue = operationQueue
    super.init()
    self.session = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
  }

  public func getTransitionData(forRequest request: URLRequest) -> TransitionDataProviderTask {
    let task = URLDataProviderTask(task: session.dataTask(with: request))
    updateTaskRegister {
      $0[task.sessionDataTask.taskIdentifier] = task
    }
    return task
  }

}

extension URLSessionTransitionDataProvider: URLSessionTaskDelegate {

  public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
     updateTaskRegister {
      $0.removeValue(forKey: task.taskIdentifier).map { (dataProviderTask: URLDataProviderTask) in
        dataProviderTask.result.error = error
        dataProviderTask.result.response = task.response
        dataProviderTask.finish()
      }
     }
   }

}

extension URLSessionTransitionDataProvider: URLSessionDataDelegate {

  public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
    withTaskRegister {
      $0[dataTask.taskIdentifier].map { (dataProviderTask: URLDataProviderTask) in
        if var accumulator = dataProviderTask.result.data {
          accumulator.append(data)
          dataProviderTask.result.data = accumulator
        } else {
          dataProviderTask.result.data = data
        }
      }
    }
  }

}

private extension URLSessionTransitionDataProvider {

  func updateTaskRegister(_ block: (inout [Int: URLDataProviderTask]) throws -> Void) rethrows {
    taskRegisterSemaphore.wait()
    try block(&taskRegister)
    taskRegisterSemaphore.signal()
  }

  func withTaskRegister<R>(_ block: ([Int: URLDataProviderTask]) throws -> R) rethrows -> R {
    taskRegisterSemaphore.wait()
    let result = try block(taskRegister)
    taskRegisterSemaphore.signal()
    return result
  }

}

final class URLDataProviderTask: TransitionDataProviderTask {

  let sessionDataTask: URLSessionDataTask

  var progress: Progress { sessionDataTask.progress }

  var result: TransitionDataProviderResult = .empty

  var isCancelled: Bool {
    sessionDataTask.state == .canceling
  }

  let awaitGroup = DispatchGroup()

  let finishSemaphore = DispatchSemaphore(value: 1)

  private(set) var isFinished: Bool = false

  init(task: URLSessionDataTask) {
    self.sessionDataTask = task
    awaitGroup.enter()
  }

  func resume() {
    sessionDataTask.resume()
  }

  func cancel() {
    sessionDataTask.cancel()
  }

  func await() {
    finishSemaphore.wait()
    if !isFinished {
      finishSemaphore.signal()
      awaitGroup.wait()
    } else {
      finishSemaphore.signal()
    }
  }


  internal func finish() {
    finishSemaphore.wait()
    isFinished = true
    finishSemaphore.signal()
    awaitGroup.leave()
  }

}
