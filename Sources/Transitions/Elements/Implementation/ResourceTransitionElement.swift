import Foundation

public struct ResourceTransitionElement<LinkKey, ResourceType: Resource, ParentElement: TransitionElement, UrlStrategy: TransitionURLStrategy, RequestBuilder: URLRequestBuilder> where ParentElement.TransitionResult == ResourceType, ResourceType.LinkKey == LinkKey {

  public let linkKey: LinkKey
  public let parentElement: ParentElement
  public let urlStrategy: UrlStrategy
  public let requestBuilder: RequestBuilder

}

extension ResourceTransitionElement: ChildTransitionElement {

  public var estimatedNumberOfTransitions: Int {
    parentElement.estimatedNumberOfTransitions + 1
  }

  public func transitionResult(for context: TransitionContext) throws -> Data {
    let resource = try parentElement.transitionResult(for: context)
    guard let transition = resource._links?[linkKey], let url = try urlStrategy.url(ofTransition: transition)  else {
      throw TransitionResolutionError.noTransitionFound(.init(element: self, debugDescription: "No link found for key \(linkKey) in Resource \(type(of: resource))"))
    }
    let request = try requestBuilder.request(for: url, context: context)
    return try context.data(urlRequest: request).0
  }

}

public extension TransitionElement where TransitionResult: Resource {

  func transitionThrough(link: TransitionResult.LinkKey) -> ResourceTransitionElement<TransitionResult.LinkKey, TransitionResult, Self, FirstLinkTransitionURLStrategy, JustURLRequestBuilder> {
    ResourceTransitionElement(linkKey: link,
                              parentElement: self,
                              urlStrategy: FirstLinkTransitionURLStrategy.strategy,
                              requestBuilder: JustURLRequestBuilder.builder
    )
  }

}

public extension ResourceTransitionElement {

  func withUrlStrategy<T: TransitionURLStrategy>(_ strategy: T) -> ResourceTransitionElement<LinkKey, ResourceType, ParentElement, T, RequestBuilder> {
    .init(linkKey: linkKey,
          parentElement: parentElement,
          urlStrategy: strategy,
          requestBuilder: requestBuilder)
  }

  func withRequestBuilder<T: URLRequestBuilder>(_ requestBuilder: T) -> ResourceTransitionElement<LinkKey, ResourceType, ParentElement, UrlStrategy, T> {
    return .init(linkKey: linkKey, parentElement: parentElement, urlStrategy: urlStrategy, requestBuilder: requestBuilder)
  }

}
