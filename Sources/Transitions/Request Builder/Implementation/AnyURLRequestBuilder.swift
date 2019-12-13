import Foundation

public struct AnyURLRequestBuilder: URLRequestBuilder {

  public var base: URLRequestBuilder

  public init<T: URLRequestBuilder>(base: T) {
    self.base = base
  }

  public func request(for url: URL, context: TransitionContext) throws -> URLRequest {
    return try base.request(for: url, context: context)
  }

}

extension URLRequestBuilder {

  func erasingType() -> AnyURLRequestBuilder {
    AnyURLRequestBuilder(base: self)
  }

}
