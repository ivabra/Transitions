import Foundation

public class AnyTransitionTask<TaskResult>: TransitionTask<TaskResult> {

  private let _isCancelled: () -> Bool
  private let _cancel: () -> Void
  private let _progress: () -> Progress
  private let _getResult: () throws -> TaskResult

  override public func getResult() throws -> TaskResult {
    try _getResult()
  }

  override public var isCancelled: Bool {
    _isCancelled()
  }

  override public func cancel() {
    _cancel()
  }

  override public var progress: Progress {
    _progress()
  }

  init<Base: TransitionTaskProtocol>(base: Base) where Base.TaskResult == TaskResult {
    _isCancelled = { base.isCancelled }
    _cancel = { base.cancel() }
    _progress = { base.progress }
    _getResult = { try base.getResult() }
  }

}
