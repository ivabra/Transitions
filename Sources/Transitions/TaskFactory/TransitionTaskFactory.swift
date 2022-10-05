


public protocol TransitionTaskFactory {
  func task<TransitionResult>(for path: any TransitionElement<TransitionResult>) -> TransitionTask<TransitionResult>
}
