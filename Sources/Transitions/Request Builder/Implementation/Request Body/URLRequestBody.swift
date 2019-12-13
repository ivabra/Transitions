import Foundation

public protocol URLRequestBody {

  func requestBody(in context: TransitionContext) throws -> Data

}
