import Foundation

internal func makeDictionary<T: CodingKey, R:Decodable>(decoder: Decoder) throws -> [T: R] where T:Hashable {
  let container = try decoder.container(keyedBy: T.self)
  var data = [T: R]()
  for key in container.allKeys {
     let result = try container.decode(R.self, forKey: key)
     data[key] = result
  }
  return data
}

extension URL {

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
