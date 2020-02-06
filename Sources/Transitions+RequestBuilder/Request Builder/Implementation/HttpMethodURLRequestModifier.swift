import Foundation
import Transitions_Core

public struct HttpMethodURLRequestModifier<Parent: URLRequestBuilder>: URLRequestBuilder {

  public let parent: Parent
  public let method: HttpMethod

  public func request(for url: URL, context: TransitionContext) throws -> URLRequest {
    var request = try parent.request(for: url, context: context)
    request.httpMethod = method.rawValue
    return request
  }

  public var description: String {
    "\(parent) & \(method.rawValue)"
  }

}

public extension URLRequestBuilder {

  func method(_ method: HttpMethod) -> HttpMethodURLRequestModifier<Self> {
    .init(parent: self, method: method)
  }

}

public func method(_ method: HttpMethod) -> HttpMethodURLRequestModifier<JustURLRequestBuilder> {
  .init(parent: .builder, method: method)
}
