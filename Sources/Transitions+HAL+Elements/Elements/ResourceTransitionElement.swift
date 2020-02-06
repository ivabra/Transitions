import Foundation
import Transitions_Core
import Transitions_HAL_Models
import Transitions_RequestBuilder
import Transitions_URLStrategy

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

  public var description: String {
    "\(parentElement) -> \(TransitionResult.self) by \(linkKey.stringValue) (\(urlStrategy), \(requestBuilder))"
  }

}

public extension ResourceTransitionElement {

  func urlStrategy<T: TransitionURLStrategy>(_ strategy: T) -> ResourceTransitionElement<LinkKey, ResourceType, ParentElement, T, RequestBuilder> {
    .init(linkKey: linkKey,
          parentElement: parentElement,
          urlStrategy: strategy,
          requestBuilder: requestBuilder)
  }

  func request<T: URLRequestBuilder>(_ requestBuilder: T) -> ResourceTransitionElement<LinkKey, ResourceType, ParentElement, UrlStrategy, T> {
    .init(linkKey: linkKey, parentElement: parentElement, urlStrategy: urlStrategy, requestBuilder: requestBuilder)
  }

  func request<T: URLRequestBuilder>(_ requestBuilder: (RequestBuilder) -> T) -> ResourceTransitionElement<LinkKey, ResourceType, ParentElement, UrlStrategy, T> {
    request(requestBuilder(self.requestBuilder))
  }

}
