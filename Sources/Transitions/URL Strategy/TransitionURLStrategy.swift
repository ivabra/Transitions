import Foundation


public protocol TransitionURLStrategy: CustomStringConvertible {
  func url(ofTransition transition: Transition) throws -> URL?
}
