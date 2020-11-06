

public struct JustTransitionElement<TransitionResult> {

  public let result: TransitionResult

  public init(_ result: TransitionResult) {
    self.result = result
  }

}

extension JustTransitionElement: TransitionElement {

  public var estimatedNumberOfTransitions: Int { 0 }
  
  public func transitionResult(for context: TransitionContext) throws -> TransitionResult {
    result
  }

  public var description: String {
    String(describing: result)
  }

}

public func transitionElement<T>(of value: T) -> JustTransitionElement<T> {
  return JustTransitionElement(value)
}
