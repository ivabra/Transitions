import Foundation


public final class ConcreteTransitionTask<Path, Context>: TransitionTask<Path.TransitionResult> where Path:TransitionElement, Context: TransitionContext & CancellableTransitionContext & ProgressObservableTransitionContext {

  let path: Path
  let context: Context
  let progressPerTransition: Int64 = 100
  let sem = DispatchSemaphore(value: 1)

  private var result: WrappedResult?

  override public var isCancelled: Bool {
    context.isCancelled
  }

  override public var progress: Progress {
    context.progress
  }

  public init(path: Path, context: Context) {
    self.path = path
    self.context = context
  }

  override public func getResult() -> Result<Path.TransitionResult, Error> {
    sem.wait()
    defer {
      sem.signal()
    }
    if let result = self.result {
      return result
    }
    if context.isCancelled {
      return .failure(TransitionResolutionError.cancelled)
    }
    context.progressPerTransition = progressPerTransition
    context.progress.totalUnitCount = Int64(path.estimatedNumberOfTransitions) * progressPerTransition
    context.progress.completedUnitCount = 0

    let result: WrappedResult
    do {
      result = .success(try path.transitionResult(for: context))
    } catch {
      result = .failure(error)
    }
    if let existingResult = self.result {
      return existingResult
    } else {
      self.result = result
      return result
    }
  }

  override public func cancel() {
    if self.result == nil {
      self.result = .failure(TransitionResolutionError.cancelled)
    }
    context.cancel()
  }


}
