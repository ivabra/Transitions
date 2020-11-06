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

  public var description: String {
    "\(parent) & path(\(pathComponents))"
  }

}

public extension URLRequestBuilder {

  func appendingPathComponents(_ pathComponents: [String]) -> AppendingPathComponentsURLRequestModifier<Self> {
    .init(pathComponents: pathComponents, parent: self)
  }

}

public func appendingPathComponents(_ pathComponents: [String]) -> AppendingPathComponentsURLRequestModifier<JustURLRequestBuilder> {
  JustURLRequestBuilder.builder.appendingPathComponents(pathComponents)
}
