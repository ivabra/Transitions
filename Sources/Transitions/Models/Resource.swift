import Foundation

public protocol Resource {

  associatedtype LinkKey: LinksCodingKey

  var _links: Links<LinkKey>? { get }

}


extension Optional: Resource where Wrapped: Resource {

  public var _links: Links<Wrapped.LinkKey>? {
    self?._links
  }

}
