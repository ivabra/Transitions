import Foundation
import Transitions_Core

public struct BodyURLRequestModifier<Body: URLRequestBody, ParentBuilder: URLRequestBuilder> {

  public let body: Body
  public let parentBuilder: ParentBuilder

}

extension BodyURLRequestModifier: URLRequestBuilder {

  public func request(for url: URL, context: TransitionContext) throws -> URLRequest {
    var request = try parentBuilder.request(for: url, context: context)
    request.httpBody = try body.requestBody(in: context)
    if let contentType = body.contentType {
      request.setValue(contentType, forHTTPHeaderField: "Content-Type")
    }
    return request
  }

  public var description: String {
    "\(parentBuilder) & body(\(body))"
  }

}


public extension URLRequestBuilder {

  func requestBody<Body: URLRequestBody>(_ body: Body) -> BodyURLRequestModifier<Body, Self> {
    .init(body: body, parentBuilder: self)
  }

}

func requestBody<Body: URLRequestBody>(_ body: Body) -> BodyURLRequestModifier<Body, JustURLRequestBuilder> {
  .init(body: body, parentBuilder: .builder)
}
