import Foundation

public enum TransitionResolutionError: Error {

  case noTransitionFound(_ context: Context)
  case noResponse(_ request: URLRequest)
  case cancelled

  public struct Context {
    public let element: Any
    public let debugDescription: String

    public init(element: Any, debugDescription: String) {
      self.element = element
      self.debugDescription = debugDescription
    }
  }

}
