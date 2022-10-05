

public struct AnyTransitionElement<TransitionResult> {

  public let base: Any
  private let getEstimatedNumberOfTransitions: () -> Int
  private let getResult: (_ context: TransitionContext) throws -> TransitionResult
  private let getDescription: () -> String

  public init<Element: TransitionElement>(_ element: Element) where Element.TransitionResult == TransitionResult {
    self.base = element
    getEstimatedNumberOfTransitions =  { element.estimatedNumberOfTransitions }
    getResult = element.transitionResult
    getDescription = { element.description }
  }

}

extension AnyTransitionElement: TransitionElement {

  public var estimatedNumberOfTransitions: Int {
     getEstimatedNumberOfTransitions()
   }

  public func transitionResult(for context: TransitionContext) throws -> TransitionResult {
    try getResult(context)
  }

  public var description: String {
    getDescription()
  }

}


public extension TransitionElement {

  func erasingType() -> AnyTransitionElement<TransitionResult> {
    AnyTransitionElement(self)
  }
    
}
