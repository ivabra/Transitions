import Foundation
 import Transitions_Core

public protocol URLRequestBody: CustomStringConvertible {

  func requestBody(in context: TransitionContext) throws -> Data

}
