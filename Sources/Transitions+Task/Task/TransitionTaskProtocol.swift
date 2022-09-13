import Foundation

public protocol TransitionTaskProtocol: AnyObject {

  associatedtype TaskResult

  var isCancelled: Bool { get }

  var progress: Progress { get }

  func getResult() -> WrappedResult

  func cancel()

}

public extension TransitionTaskProtocol {

  typealias WrappedResult = Result<TaskResult, Error>

  func start(in queue: DispatchQueue = .global()) {
    queue.async {
      _ = self.getResult()
    }
  }

}




