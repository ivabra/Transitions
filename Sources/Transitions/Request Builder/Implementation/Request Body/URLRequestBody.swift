import Foundation
 

public protocol URLRequestBody: CustomStringConvertible {

  var contentType: String? { get }
  
  func requestBody(in context: TransitionContext) throws -> Data

}
