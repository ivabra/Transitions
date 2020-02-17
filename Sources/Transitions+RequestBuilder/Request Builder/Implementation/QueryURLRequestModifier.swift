import Foundation
import Transitions_Core
import Transitions_CommonUtils

public struct QueryURLRequestModifier<Parent: URLRequestBuilder>: URLRequestBuilder {

  public let parent: Parent
  public let queryParameters: [String: Any]
  public let allowedCharacters: CharacterSet

  public init(parent: Parent, queryParameters: [String: Any], allowedCharacters: CharacterSet) {
    self.parent = parent
    self.queryParameters = queryParameters
    self.allowedCharacters = allowedCharacters
  }

  public func request(for url: URL, context: TransitionContext) throws -> URLRequest {
    var request = try parent.request(for: url, context: context)
    request.url = request.url?.appendingUrlParameters(queryParameters, allowedCharacters: allowedCharacters)
    return request
  }

  public var description: String {
    "\(parent) & query(\(queryParameters))"
  }

}

public extension URLRequestBuilder {

  func urlParameters(_ parameters: [String: Any], allowedCharacters: CharacterSet) -> QueryURLRequestModifier<Self> {
    .init(parent: self, queryParameters: parameters, allowedCharacters: allowedCharacters)
  }

}

public func urlParameters(_ parameters: [String: Any], allowedCharacters: CharacterSet) -> QueryURLRequestModifier<JustURLRequestBuilder> {
  .init(parent: .builder, queryParameters: parameters, allowedCharacters: allowedCharacters)
}


