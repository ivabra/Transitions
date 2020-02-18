import Foundation

public extension URL {

  func appendingUrlParameters(_ urlParameters: [String: Any], allowedCharacters: CharacterSet) -> URL? {
    guard urlParameters.isEmpty == false else { return self }
    let queryString = urlParameters
      .compactMap { key, value in
        String(describing: value)
          .addingPercentEncoding(withAllowedCharacters: allowedCharacters)
          .map { encodedValue in "\(key)=\(encodedValue)" }
    }
    .joined(separator: "&")
    let separator = self.query == nil ? "?" : "&"
    let string = absoluteString + separator + queryString
    return URL(string: string)
  }

}
