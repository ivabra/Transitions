import Foundation

public typealias LinksCodingKey = CodingKey & Hashable

public struct Links<Key>: LinksProtocol where Key: LinksCodingKey {

  private var storage: [Key: Transition]

  public init(from decoder: Decoder) throws {
    storage = try makeDictionary(decoder: decoder)
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: Key.self)
    for (key, value) in storage {
      try container.encode(value, forKey: key)
    }
  }

  public subscript(value: Key) -> Transition? {
    set {
      storage[value] = newValue
    }
    get {
      return storage[value]
    }
  }

}
