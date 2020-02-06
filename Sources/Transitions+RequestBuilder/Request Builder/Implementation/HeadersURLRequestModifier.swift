import Foundation
import Transitions_Core

public struct HeadersURLRequestModifier<Parent: URLRequestBuilder>: URLRequestBuilder {

  public let parent: Parent
  public var headers: [String: [String]]


  public func request(for url: URL, context: TransitionContext) throws -> URLRequest {
    var request = try parent.request(for: url, context: context)
    for (name, values) in headers {
      for value in values {
        request.addValue(value, forHTTPHeaderField: name)
      }
    }
    return request
  }

  public var description: String {
    "\(parent) & headers(\(headers))"
  }

}

public extension URLRequestBuilder {

  func headers(_ headers: [String: [String]]) -> HeadersURLRequestModifier<Self> {
    .init(parent: self, headers: headers)
  }

}

public func headers(_ headers: [String: [String]]) -> HeadersURLRequestModifier<JustURLRequestBuilder> {
  .init(parent: .builder, headers: headers)
}
