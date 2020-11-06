import Foundation

public struct TransitionDataProviderResult {

  public var data: Data?
  public var response: URLResponse?
  public var error: Error?

  public init(data: Data? = nil, response: URLResponse? = nil, error: Error? = nil) {
    self.data = data
    self.response = response
    self.error = error
  }

  public static let empty = TransitionDataProviderResult(data: nil, response: nil, error: nil)

}
