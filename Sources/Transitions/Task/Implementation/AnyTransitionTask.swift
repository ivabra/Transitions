import Foundation

public class AnyTransitionTask<TaskResult>: TransitionTask<TaskResult> {

  #if DEBUG
  private let base: Any
  #endif

  private let _isCancelled: () -> Bool
  private let _cancel: () -> Void
  private let _progress: () -> Progress
  private let _getResult: () -> Swift.Result<TaskResult, Error>

  public override func getResult() -> Result<TaskResult, Error> {
    _getResult()
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

    #if DEBUG
    self.base = base
    #endif

    _isCancelled = { base.isCancelled }
    _cancel = { base.cancel() }
    _progress = { base.progress }
    _getResult = { base.getResult() }
  }

}
