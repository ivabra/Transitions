

public struct VoidTranisitonElement<ParentElement: TransitionElement> {

  public let parentElement: ParentElement

  public init(parentElement: ParentElement) {
    self.parentElement = parentElement
  }

}


extension VoidTranisitonElement: ChildTransitionElement {
    
  public typealias TransitionResult = Void

  public func transitionResult(for context: TransitionContext) throws -> Void {
    _ = try parentElement.transitionResult(for: context)
  }

}

public extension TransitionElement {

  func asVoid() -> VoidTranisitonElement<Self> {
    VoidTranisitonElement(parentElement: self)
  }

}
