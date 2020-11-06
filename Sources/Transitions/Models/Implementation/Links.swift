import Foundation


public typealias LinksCodingKey = CodingKey & Hashable

public struct Links<Key>: LinksProtocol where Key: LinksCodingKey {

  private var transitions: [Key: Transition]

  public init(transitions: [Key: Transition]) {
    self.transitions = transitions
  }

  public init(from decoder: Decoder) throws {
    transitions = try decoder.container(keyedBy: Key.self).decodeDictionary(withValueType: Transition.self)
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: Key.self)
    for (key, value) in transitions {
      try container.encode(value, forKey: key)
    }
  }

  public subscript(value: Key) -> Transition? {
    set {
      transitions[value] = newValue
    }
    get {
      return transitions[value]
    }
  }

}
