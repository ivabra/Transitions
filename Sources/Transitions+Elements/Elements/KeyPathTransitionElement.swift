import Transitions_Core

public struct KeyPathTransitionElement<TransitionResult, ParentElement> where ParentElement: TransitionElement  {

  public typealias KeyPathType = KeyPath<ParentElement.TransitionResult, TransitionResult>

  public let parentElement: ParentElement
  public let keyPath: KeyPathType

  public init(keyPath: KeyPathType, parentElement: ParentElement) {
    self.keyPath = keyPath
    self.parentElement = parentElement
  }

}

extension KeyPathTransitionElement: ChildTransitionElement {

  public func transitionResult(for context: TransitionContext) throws -> TransitionResult {
    try parentElement.transitionResult(for: context)[keyPath: keyPath]
  }

  public var description: String {
    return "\(parentElement) -> \(TransitionResult.self) by Swift.KeyPath"
  }

}

public extension TransitionElement {

  func transitionThrough<NextResult>(keyPath: KeyPath<Self.TransitionResult, NextResult>) -> KeyPathTransitionElement<NextResult, Self> {
    .init(keyPath: keyPath, parentElement: self)
  }

}
