import Foundation
import Transitions_HAL_Models

public protocol TransitionURLStrategy: CustomStringConvertible {
  func url(ofTransition transition: Transition) throws -> URL?
}
