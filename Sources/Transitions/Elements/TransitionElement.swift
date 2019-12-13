import Foundation

public protocol TransitionElement {

  associatedtype TransitionResult

  var estimatedNumberOfTransitions: Int { get }

  func transitionResult(for context: TransitionContext) throws -> TransitionResult
  
}
