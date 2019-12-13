import struct Foundation.URL

public struct FirstLinkTransitionURLStrategy: TransitionURLStrategy {

  public static let strategy = FirstLinkTransitionURLStrategy()

  public func url(ofTransition transition: Transition) throws -> URL? {
    return try transition.firstUrl()
  }

}
