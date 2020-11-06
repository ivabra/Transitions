

public struct EphemeralTransitionElement<TransitionResult>: TransitionElement {

  public var estimatedNumberOfTransitions: Int { 0 }

  public func transitionResult(for context: TransitionContext) throws -> TransitionResult {
    fatalError("Getting ethemeral result with type \(TransitionResult.self) caused fatal error.")
  }

}
