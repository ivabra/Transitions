import Foundation
import Transitions_Core

public struct JSONURLRequestBody<Content>: URLRequestBody {

  public let object: Content
  public let options: JSONSerialization.WritingOptions

  public init(of object: Content, options: JSONSerialization.WritingOptions) {
    self.object = object
    self.options = options
  }

  public func requestBody(in context: TransitionContext) throws -> Data {
    try JSONSerialization.data(withJSONObject: object, options: options)
  }

  public var description: String {
    String(describing: object)
  }

}

public func jsonBody<Content>(_ content: Content, options: JSONSerialization.WritingOptions = []) -> JSONURLRequestBody<Content> {
  return JSONURLRequestBody(of: content, options: options)
}
