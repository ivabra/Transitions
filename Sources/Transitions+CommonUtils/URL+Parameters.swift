import Foundation

public extension URL {

  func appendingUrlParameters(_ urlParameters: [String: Any], allowedCharacters: CharacterSet) -> URL? {
    guard urlParameters.isEmpty == false else { return self }
    return urlParameters
      .compactMap { key, value in
        String(describing: value)
          .addingPercentEncoding(withAllowedCharacters: allowedCharacters)
          .map { encodedValue in "\(key)=\(encodedValue)" }
    }
    .joined(separator: "&")
    .addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    .flatMap { query -> URL? in
      let firstSeparator = self.query == nil ? "?" : "&"
      let string = absoluteString + firstSeparator + query
      return URL(string: string)
    }
  }

}
