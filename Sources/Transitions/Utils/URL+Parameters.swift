import Foundation

public extension URL {

  func appendingUrlParameters<T: URLQueryParametersArrayConvertable>(_ urlParameters: T, allowedCharacters: CharacterSet) -> URL? {
    let parameters = urlParameters.asURLQueryParametersArray()
    guard parameters.isEmpty == false else { return self }
    let queryString = parameters
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


