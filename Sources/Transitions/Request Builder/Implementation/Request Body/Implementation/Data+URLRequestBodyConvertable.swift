import Foundation

extension Data: URLRequestBody {

  public func requestBody(in context: TransitionContext) throws -> Data {
    return self
  }

}
