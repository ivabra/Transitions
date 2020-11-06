import Foundation

public class URLSessionTransitionDataProvider: NSObject, TransitionDataProvider {

  // MARK: Public

  public var delegate: URLSessionTransitionDataProviderDelegate?

  public init(configuration: URLSessionConfiguration,
              operationQueue: OperationQueue) {
    self.operationQueue = operationQueue
    super.init()
    updateSession(configuration: configuration, cancelTasks: false)
  }

  public func getTransitionData(forRequest request: URLRequest) throws -> TransitionDataProviderTask {

    guard let session = self.session else {
      fatalError("Session should be initialized")
    }

    let dataTask = try delegate.map {
      var request = request
      try $0.urlSessionTransitionDataProvider(self, willPerformRequest: &request)
      return session.dataTask(with: request)
    } ?? session.dataTask(with: request)

    let task = URLDataProviderTask(task: dataTask)

    updateTaskRegister {
      $0[task.sessionDataTask.taskIdentifier] = task
    }

    return task
  }

  public func setSessionConfiguration(_ configuration: URLSessionConfiguration, cancelTasks: Bool) {
    updateSession(configuration: configuration, cancelTasks: cancelTasks)
  }

  // MARK: Private

  private let operationQueue: OperationQueue

  private let taskRegisterSemaphore = DispatchSemaphore(value: 1)

  private var taskRegister = [Int: URLDataProviderTask]()

  private var session: URLSession?

}

private extension URLSessionTransitionDataProvider {

  func createSession(configuration: URLSessionConfiguration) -> URLSession {
    URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
  }

  func updateSession(configuration: URLSessionConfiguration, cancelTasks: Bool) {
    if let oldSession = self.session {
      if cancelTasks {
        oldSession.invalidateAndCancel()
      } else {
        oldSession.finishTasksAndInvalidate()
      }
    }
    self.session = createSession(configuration: configuration)
  }

}

extension URLSessionTransitionDataProvider: URLSessionTaskDelegate {

  public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
     updateTaskRegister {
      $0.removeValue(forKey: task.taskIdentifier).map { (dataProviderTask: URLDataProviderTask) in
        dataProviderTask.result.error = error
        dataProviderTask.result.response = task.response
        if error != nil {
          dataProviderTask.progress.completedUnitCount = dataProviderTask.progress.totalUnitCount
        }
        dataProviderTask.finish()
      }
     }
   }

}

extension URLSessionTransitionDataProvider: URLSessionDataDelegate {

  public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
    withTaskRegister {
      $0[dataTask.taskIdentifier].map { (dataProviderTask: URLDataProviderTask) in
        dataProviderTask.progress.totalUnitCount = max(0, dataTask.countOfBytesExpectedToReceive + dataTask.countOfBytesExpectedToSend)
        dataProviderTask.progress.completedUnitCount = max(0, dataTask.countOfBytesSent + dataTask.countOfBytesReceived)
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

  let progress = Progress()

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
