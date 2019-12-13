import Foundation

public struct AppendingPathComponentsURLRequestModifier<Parent: URLRequestBuilder>: URLRequestBuilder {

  public var parent: Parent
  public var pathComponents: [String]

  public init(pathComponents: [String], parent: Parent) {
    self.parent = parent
    self.pathComponents = pathComponents
  }

  public func request(for url: URL, context: TransitionContext) throws -> URLRequest {
    var request = try parent.request(for: url, context: context)
    for component in pathComponents {
      request.url?.appendPathComponent(component)
    }
    return request
  }

}

public extension URLRequestBuilder {

  func appendingPathComponents(_ pathComponents: [String]) -> AppendingPathComponentsURLRequestModifier<Self> {
    .init(pathComponents: pathComponents, parent: self)
  }

}

public extension DataTransitionElement {

  func appendingPathComponents(_ pathComponents: [String]) -> DataTransitionElement<AppendingPathComponentsURLRequestModifier<RequestBuilder>, ParentElement> {
    withRequestBuilder(requestBuilder.appendingPathComponents(pathComponents))
  }

}

public extension ResourceTransitionElement {

  func appendingPathComponents(_ pathComponents: [String]) -> ResourceTransitionElement<LinkKey, ResourceType, ParentElement, UrlStrategy, AppendingPathComponentsURLRequestModifier<RequestBuilder>> {
    withRequestBuilder(requestBuilder.appendingPathComponents(pathComponents))
  }

}
