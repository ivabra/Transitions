import Foundation



public struct DataTransitionElement<RequestBuilder, ParentElement> where RequestBuilder: URLRequestBuilder, ParentElement: TransitionElement, ParentElement.TransitionResult == URL {

  public let parentElement: ParentElement
  public let requestBuilder: RequestBuilder

  public init(requestBuilder: RequestBuilder, parentElement: ParentElement) {
    self.requestBuilder = requestBuilder
    self.parentElement = parentElement
  }

}

extension DataTransitionElement: ChildTransitionElement {
    
  public typealias TransitionResult = Data

  public var estimatedNumberOfTransitions: Int { 1 }

  public func transitionResult(for context: TransitionContext) throws -> Data {
    let url = try parentElement.transitionResult(for: context)
    let (data, _) = try context.data(urlRequest: try requestBuilder.request(for: url, context: context))
    return data
  }

}

public extension DataTransitionElement {

  func request<T: URLRequestBuilder>(_ builder: T) -> DataTransitionElement<T, ParentElement> {
    .init(requestBuilder: builder, parentElement: parentElement)
  }

  func request<T: URLRequestBuilder>(_ builder: (RequestBuilder) -> T) -> DataTransitionElement<T, ParentElement> {
    request(builder(self.requestBuilder))
  }
  
}


public extension TransitionElement where TransitionResult == URL {

  func data() -> DataTransitionElement<JustURLRequestBuilder, Self> {
    .init(requestBuilder: JustURLRequestBuilder.builder, parentElement: self)
  }

  func data<RequestBuilder: URLRequestBuilder>(requestBuilder: RequestBuilder) -> DataTransitionElement<RequestBuilder, Self> {
    .init(requestBuilder: requestBuilder, parentElement: self)
  }

}

//public func urlElement(_ url: URL) -> Just<JustURLRequestBuilder> {
//  urlElement(url, requestBuilder: JustURLRequestBuilder.builder)
//}
//
//public func urlElement<Builder: URLRequestBuilder>(_ url: URL, requestBuilder: Builder) -> URLTransitionElement<Builder> {
//  URLTransitionElement(url: url, requestBuilder: requestBuilder)
//}

