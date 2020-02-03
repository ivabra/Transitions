public struct AnyResource<LinkKey>: Codable, Resource where LinkKey: LinksCodingKey {

  public let _links: Links<LinkKey>?

  public init(links: Links<LinkKey>? = nil) {
    self._links = links
  }

}

public extension AnyResource {

  init<Wrapped: Resource>(_ resource: Wrapped) where LinkKey == Wrapped.LinkKey {
    self.init(links: resource._links)
  }

}

public extension Resource {

  static var anyResourceType: AnyResource<LinkKey>.Type {
    return AnyResource<LinkKey>.self
  }

}
