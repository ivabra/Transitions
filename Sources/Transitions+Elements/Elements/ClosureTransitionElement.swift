import Transitions_Core

public struct BlockTransitionElement<ParentElement: TransitionElement, TransitionResult>: ChildTransitionElement {

  typealias BlockType =  (ParentElement.TransitionResult) throws -> TransitionResult

  public var estimatedNumberOfTransitions: Int { 0 }

  public var parentElement: ParentElement
  public var description: String
  public var block: BlockType

  public init(parent: ParentElement, description: String, block: @escaping BlockType) {
    self.parentElement = parent
    self.block = block
    self.description = description
  }

  public func transitionResult(for context: TransitionContext) throws -> TransitionResult {
    let parentResult = try parentElement.transitionResult(for: context)
    return try block(parentElement)
  }

}

public extension TransitionElement {

  func transitionThroughtBlock<ResultType>(_ description: String, block: BlockTransitionElement<Self, ResultType>.BlockType) -> BlockTransitionElement<Self, ResultType> {
    BlockTransitionElement(parent: self, description: description, block: block)
  }

}
