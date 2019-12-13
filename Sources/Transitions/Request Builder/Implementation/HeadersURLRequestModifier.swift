import Foundation

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

}
