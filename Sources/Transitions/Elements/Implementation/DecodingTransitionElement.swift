import Foundation

public struct DecodingTransitionElement<DecodingType, ParentElement> where ParentElement: TransitionElement, ParentElement.TransitionResult == Data, DecodingType: Decodable {

  public let parentElement: ParentElement

}

extension DecodingTransitionElement: ChildTransitionElement {

  public func transitionResult(for context: TransitionContext) throws -> DecodingType {
     let data = try parentElement.transitionResult(for: context)
     return try context.decode(DecodingType.self, from: data)
   }

}

public extension TransitionElement where TransitionResult == Data {

  func decoding<T: Decodable>(_ type: T.Type) -> DecodingTransitionElement<T, Self> {
    DecodingTransitionElement<T, Self>(parentElement: self)
  }

}

