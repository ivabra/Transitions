import Foundation

public struct TimeoutIntervalURLRequestModifier<Parent: URLRequestBuilder>: URLRequestBuilder {

  public let parent: Parent
  public let timeoutInterval: TimeInterval

  public func request(for url: URL, context: TransitionContext) throws -> URLRequest {
    var request = try parent.request(for: url, context: context)
    request.timeoutInterval = timeoutInterval
    return request
  }

}

public extension URLRequestBuilder {

  func timeoutInterval(_ interval: TimeInterval) -> TimeoutIntervalURLRequestModifier<Self> {
    TimeoutIntervalURLRequestModifier(parent: self, timeoutInterval: interval)
  }

}


public extension ResourceTransitionElement {

  func timeoutInterval(_ interval: TimeInterval) -> ResourceTransitionElement<LinkKey, ResourceType, ParentElement, UrlStrategy, TimeoutIntervalURLRequestModifier<RequestBuilder>> {
    withRequestBuilder(requestBuilder.timeoutInterval(interval))
  }

}
