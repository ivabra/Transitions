import Foundation

public protocol URLRequestBuilder {

  func request(for url: URL, context: TransitionContext) throws -> URLRequest

}
