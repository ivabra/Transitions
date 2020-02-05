import Foundation
import Transitions_Core

public struct EncodableURLRequestBody<Content: Encodable> {

  public var content: Content
  public var contentType: String?

  public init(content: Content, contentType: String?) {
    self.content = content
    self.contentType = contentType
  }

}

extension EncodableURLRequestBody: URLRequestBody {

  public func requestBody(in context: TransitionContext) throws -> Data {
    try context.encode(content)
  }

  public var description: String {
    String(describing: content)
  }

}


public func encodableBody<Content>(_ content: Content, contentType: String? = nil) -> EncodableURLRequestBody<Content> where Content: Encodable {
  .init(content: content, contentType: contentType)
}
