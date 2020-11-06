import Foundation

public struct StringKey: LinksCodingKey {

  public var stringValue: String

  public init?(stringValue: String) {
    self.stringValue = stringValue
  }

  public var intValue: Int? { return nil }

  public init?(intValue: Int) {
    return nil
  }

}

extension StringKey: ExpressibleByStringLiteral {

  public typealias StringLiteralType = String

  public init(stringLiteral value: Self.StringLiteralType) {
    self.stringValue = value
  }

}

public extension StringKey {
  static let embedded: StringKey = "_embedded"
  static let links: StringKey = "_links"
}

public enum SpecializedKeys: String, CodingKey {
  case embedded = "_embedded"
  case links = "_links"
}
