import Foundation

public protocol TransitionURLStrategy {
  func url(ofTransition transition: Transition) throws -> URL?
}
