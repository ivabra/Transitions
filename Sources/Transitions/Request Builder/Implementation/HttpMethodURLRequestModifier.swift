import Foundation

public struct HttpMethodURLRequestModifier<Parent: URLRequestBuilder>: URLRequestBuilder {

  public let parent: Parent
  public let method: HttpMethod

  public func request(for url: URL, context: TransitionContext) throws -> URLRequest {
    var request = try parent.request(for: url, context: context)
    request.httpMethod = method.rawValue
    return request
  }

}

public extension URLRequestBuilder {

  func method(_ method: HttpMethod) -> HttpMethodURLRequestModifier<Self> {
    HttpMethodURLRequestModifier(parent: self, method: method)
  }

}

public extension DataTransitionElement {

  func method(_ method: HttpMethod) -> DataTransitionElement<HttpMethodURLRequestModifier<RequestBuilder>, ParentElement> {
    return withRequestBuilder(requestBuilder.method(method))
  }

}

public extension ResourceTransitionElement {

  func method(_ method: HttpMethod) -> ResourceTransitionElement<LinkKey, ResourceType, ParentElement, UrlStrategy, HttpMethodURLRequestModifier<RequestBuilder>> {
    withRequestBuilder(requestBuilder.method(method))
  }

}
