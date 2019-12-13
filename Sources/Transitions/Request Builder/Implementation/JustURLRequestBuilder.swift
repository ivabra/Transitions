import Foundation

public struct JustURLRequestBuilder: URLRequestBuilder {

  public static let builder = JustURLRequestBuilder()

  public func request(for url: URL, context: TransitionContext) throws -> URLRequest {
    URLRequest(url: url)
  }

}

