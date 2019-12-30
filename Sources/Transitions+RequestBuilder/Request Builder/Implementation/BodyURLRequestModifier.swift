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



//public struct EncodableBodyRequestModifier<EncodableBody: Encodable, ParentBuilder: URLRequestBuilder>: URLRequestBuilder {
//
//  public let base: ParentBuilder
//  public let encodableBody: EncodableBody
//
//  public func request(for url: URL, context: TransitionContext) throws -> URLRequest {
//    var request = try base.request(for: url, context: context)
//    request.httpBody = try context.encode(encodableBody) // try JSONSerialization.data(withJSONObject: jsonObject, options: jsonWritingOptions)
//    return request
//  }
//
//}
//
//public extension URLRequestBuilder {
//
//  func encodableBody<Body: Encodable>(_ body: Body) -> EncodableBodyRequestModifier<Body, Self> {
//    .init(base: self, encodableBody: body)
//  }
//
//}
//
//public extension DataTransitionElement {
//
//  func encodableBody<Body: Encodable>(_ body: Body) -> DataTransitionElement<EncodableBodyRequestModifier<Body, RequestBuilder>, ParentElement> {
//    withRequestBuilder(requestBuilder.encodableBody(body))
//  }
//
//}
//
//public extension ResourceTransitionElement {
//
//  func encodableBody<Body: Encodable>(_ body: Body) -> ResourceTransitionElement<LinkKey, ResourceType, ParentElement, UrlStrategy, EncodableBodyRequestModifier<Body, RequestBuilder>> {
//    withRequestBuilder(requestBuilder.encodableBody(body))
//  }
//
//}
