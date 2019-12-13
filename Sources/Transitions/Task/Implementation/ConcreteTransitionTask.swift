import Foundation

public final class ConcreteTransitionTask<Path, Context>: TransitionTask<Path.TransitionResult> where Path:TransitionElement, Context: TransitionContext & CancellableTransitionContext & ProgressObservableTransitionContext {

  let path: Path
  let context: Context
  let progressPerTransition: Int64 = 100
  let sem = DispatchSemaphore(value: 1)

  private var result: Path.TransitionResult?

  override public var isCancelled: Bool { context.isCancelled }

  override public var progress: Progress {
    context.progress
  }

  public init(path: Path, context: Context) {
    self.path = path
    self.context = context
  }

  override public func getResult() throws -> Path.TransitionResult {
    sem.wait()
    defer {
      sem.signal()
    }
    if let result = self.result {
      return result
    }
    if context.isCancelled {
      throw TransitionResolutionError.cancelled
    }
    context.progressPerTransition = progressPerTransition
    context.progress.totalUnitCount = Int64(path.estimatedNumberOfTransitions) * progressPerTransition
    context.progress.completedUnitCount = 0
    let result = try path.transitionResult(for: context)
    self.result = result
    return result
  }

  override public func cancel() {
    context.cancel()
  }


}
