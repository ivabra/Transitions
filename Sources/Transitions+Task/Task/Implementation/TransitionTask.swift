import Foundation

public class TransitionTask<TaskResult>: TransitionTaskProtocol {

  public var isCancelled: Bool {
    funcNotImplemented()
  }

  public func getResult() -> Result<TaskResult, Error> {
    funcNotImplemented()
  }

  public func cancel() {
    funcNotImplemented()
  }

  public var progress: Progress {
    funcNotImplemented()
  }

}
