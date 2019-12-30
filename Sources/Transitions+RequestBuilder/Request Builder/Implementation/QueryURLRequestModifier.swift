import Foundation
import Transitions_Core
import Transitions_CommonUtils

public struct QueryURLRequestModifier<Parent: URLRequestBuilder>: URLRequestBuilder {

  public let parent: Parent
  public let queryParameters: [String: Any]

  public func request(for url: URL, context: TransitionContext) throws -> URLRequest {
    var request = try parent.request(for: url, context: context)
    request.url = request.url?.appendingUrlParameters(queryParameters)
    return request
  }

  public var description: String {
    "\(parent) & query(\(queryParameters))"
  }

}

public extension URLRequestBuilder {

  func urlParameters(_ parameters: [String: Any]) -> QueryURLRequestModifier<Self> {
    QueryURLRequestModifier(parent: self, queryParameters: parameters)
  }

}


