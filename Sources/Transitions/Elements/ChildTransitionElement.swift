public protocol ChildTransitionElement: TransitionElement {

  associatedtype ParentElement: TransitionElement

  var parentElement: ParentElement { get }

}

extension ChildTransitionElement {

  public var estimatedNumberOfTransitions: Int { parentElement.estimatedNumberOfTransitions }

}

extension ChildTransitionElement where TransitionResult == ParentElement.TransitionResult {

  public func transitionResult(for context: TransitionContext) throws -> TransitionResult {
    try parentElement.transitionResult(for: context)
  }

}
