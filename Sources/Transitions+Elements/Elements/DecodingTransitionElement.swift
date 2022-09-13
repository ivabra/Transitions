import Foundation
import Transitions_Core

public struct DecodingTransitionElement<DecodingType, ParentElement> where ParentElement: TransitionElement, ParentElement.TransitionResult == Data, DecodingType: Decodable {

  public let parentElement: ParentElement

}

extension DecodingTransitionElement: ChildTransitionElement {
    
  public typealias TransitionResult = DecodingType

  public func transitionResult(for context: TransitionContext) throws -> DecodingType {
     let data = try parentElement.transitionResult(for: context)
     return try context.decode(DecodingType.self, from: data)
   }

  public var description: String {
    "\(parentElement) -> Decoding to \(TransitionResult.self)"
  }

}

public extension TransitionElement where TransitionResult == Data {

  func decoding<T: Decodable>(_ type: T.Type) -> DecodingTransitionElement<T, Self> {
    DecodingTransitionElement<T, Self>(parentElement: self)
  }

}

