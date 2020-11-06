public protocol URLQueryParametersArrayConvertable {

  func asURLQueryParametersArray() -> [(String, String)]

}

extension Array: URLQueryParametersArrayConvertable where Element == (String, String) {

  public func asURLQueryParametersArray() -> [(String, String)] {
    return self
  }

}

extension Dictionary: URLQueryParametersArrayConvertable where Key == String, Value == String {

  public func asURLQueryParametersArray() -> [(String, String)] {
    return self.map { ($0, $1) }
  }

}
