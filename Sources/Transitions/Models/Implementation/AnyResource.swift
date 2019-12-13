public struct AnyResource<LinkKey>: Codable, Resource where LinkKey: LinksCodingKey {

  public let _links: Links<LinkKey>?

}

