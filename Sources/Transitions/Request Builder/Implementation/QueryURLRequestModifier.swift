import Foundation



public struct QueryURLRequestModifier<Parent: URLRequestBuilder>: URLRequestBuilder {

  public let parent: Parent
  public let queryParameters: [(String, String)]
  public let allowedCharacters: CharacterSet

  public init(parent: Parent, queryParameters: [(String, String)], allowedCharacters: CharacterSet) {
    self.parent = parent
    self.queryParameters = queryParameters
    self.allowedCharacters = allowedCharacters
  }

  public func request(for url: URL, context: TransitionContext) throws -> URLRequest {
    var request = try parent.request(for: url, context: context)
    request.url = request.url?.appendingUrlParameters(queryParameters, allowedCharacters: allowedCharacters)
    return request
  }

  public var description: String {
    "\(parent) & query(\(queryParameters))"
  }

}

public extension URLRequestBuilder {

  func urlParameters(_ parameters: [(String, String)], allowedCharacters: CharacterSet) -> QueryURLRequestModifier<Self> {
    .init(parent: self, queryParameters: parameters, allowedCharacters: allowedCharacters)
  }

}

public func urlParameters(_ parameters: [(String, String)], allowedCharacters: CharacterSet) -> QueryURLRequestModifier<JustURLRequestBuilder> {
  .init(parent: .builder, queryParameters: parameters, allowedCharacters: allowedCharacters)
}
