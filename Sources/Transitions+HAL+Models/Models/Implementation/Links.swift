import Foundation
import Transitions_CommonUtils

public typealias LinksCodingKey = CodingKey & Hashable

public struct Links<Key>: LinksProtocol where Key: LinksCodingKey {

  private var storage: [Key: Transition]

  public init(from decoder: Decoder) throws {
    storage = try decoder.container(keyedBy: Key.self).decodeDictionary(withValueType: Transition.self) // makeDictionary(decoder: decoder)
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
