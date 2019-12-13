import Foundation

public struct EncodableURLRequestBody<Content: Encodable> {

  public var content: Content

  public init(content: Content) {
    self.content = content
  }

}

extension EncodableURLRequestBody: URLRequestBody {

  public func requestBody(in context: TransitionContext) throws -> Data {
    try context.encode(content)
  }

}


public func encodableBody<Content>(_ content: Content) -> EncodableURLRequestBody<Content> where Content: Encodable {
  .init(content: content)
}
