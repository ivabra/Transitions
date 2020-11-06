import Foundation


public struct DataRequestBody: URLRequestBody {

  public var data: Data

  public var contentType: String?

  public func requestBody(in context: TransitionContext) throws -> Data {
    data
  }

  public var description: String {
    "\(data.count) bytes"
  }

  public init(data: Data, contentType: String?) {
    self.data = data
    self.contentType = contentType
  }

}

extension Data: URLRequestBody {

  public var contentType: String? {
    return nil
  }

  public func requestBody(in context: TransitionContext) throws -> Data {
    return self
  }

}
