import Foundation


public protocol URLRequestBuilder: CustomStringConvertible {

  func request(for url: URL, context: TransitionContext) throws -> URLRequest

}

