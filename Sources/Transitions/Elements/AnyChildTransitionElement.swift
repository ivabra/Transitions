

public struct AnyChildTransitionElement<TransitionResult, ParentElement: TransitionElement> {

  public let base: Any

  private let getParentElement: () -> ParentElement
  private let getEstimatedNumberOfTransitions: () -> Int
  private let getTransitionResult: (TransitionContext) throws -> TransitionResult
  private let getDescription: () -> String


  init<T: ChildTransitionElement>(_ wrappedElement: T) where T.ParentElement == ParentElement, T.TransitionResult == TransitionResult {
    base = wrappedElement
    self.getTransitionResult = wrappedElement.transitionResult
    self.getParentElement = { wrappedElement.parentElement }
    self.getEstimatedNumberOfTransitions = { wrappedElement.estimatedNumberOfTransitions }
    self.getDescription = { wrappedElement.description }
  }

}

extension AnyChildTransitionElement: ChildTransitionElement {

  public var estimatedNumberOfTransitions: Int {
    getEstimatedNumberOfTransitions()
  }

  public var parentElement: ParentElement {
    getParentElement()
  }

  public func transitionResult(for context: TransitionContext) throws -> TransitionResult {
    try getTransitionResult(context)
  }

  public var description: String {
    getDescription()
  }

}

public extension ChildTransitionElement {

  func erasingTypePreservingParent() -> AnyChildTransitionElement<TransitionResult, ParentElement> {
    AnyChildTransitionElement(self)
  }

}
