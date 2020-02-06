import Foundation
import Transitions_Core

public struct JustURLRequestBuilder: URLRequestBuilder {

  public static let builder = JustURLRequestBuilder()

  public func request(for url: URL, context: TransitionContext) throws -> URLRequest {
    URLRequest(url: url)
  }

  public var description: String {
    "URLRequest"
  }

}

public func buildRequest<T: URLRequestBuilder>(block: (JustURLRequestBuilder) -> T) -> T {
  block(JustURLRequestBuilder.builder)
}
