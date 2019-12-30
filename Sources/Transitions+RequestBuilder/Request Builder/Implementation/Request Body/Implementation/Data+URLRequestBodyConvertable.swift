import Foundation
import Transitions_Core

public struct DataRequestBody: URLRequestBody {

  let data: Data

  public func requestBody(in context: TransitionContext) throws -> Data {
    data
  }

  public var description: String {
    "\(data.count) bytes"
  }

}

extension Data: URLRequestBody {

  public func requestBody(in context: TransitionContext) throws -> Data {
    return self
  }

}
