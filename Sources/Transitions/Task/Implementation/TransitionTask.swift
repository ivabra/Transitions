import Foundation

public class TransitionTask<TaskResult>: TransitionTaskProtocol {

  public var isCancelled: Bool {
    fatalError("Not implemented")
  }

  public func getResult() throws -> TaskResult {
    fatalError("Not implemented")
  }

  public func cancel() {
    fatalError("Not implemented")
  }

  public var progress: Progress {
    fatalError("Not implemented")
  }

}
