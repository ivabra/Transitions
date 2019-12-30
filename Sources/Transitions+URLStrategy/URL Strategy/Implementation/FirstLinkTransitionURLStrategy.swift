import struct Foundation.URL
import Transitions_HAL_Models

public struct FirstLinkTransitionURLStrategy: TransitionURLStrategy {

  public static let strategy = FirstLinkTransitionURLStrategy()

  public func url(ofTransition transition: Transition) throws -> URL? {
    return try transition.firstUrl()
  }

  public var description: String {
    "first link"
  }

}
