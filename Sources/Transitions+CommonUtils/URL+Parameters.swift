import Foundation

public extension URL {

  func appendingUrlParameters(_ urlParameters: [String: Any]) -> URL? {
    guard urlParameters.isEmpty == false else { return self }
    return urlParameters.map { "\($0)=\($1)" }.joined(separator: "&")
      .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
      .flatMap { query -> URL? in
      let firstSeparator = self.query == nil ? "?" : "&"
      let string = absoluteString + firstSeparator + query
      return URL(string: string)
    }
  }

}
