

public extension KeyedDecodingContainer where K: Hashable {

  func decodeDictionary<Value>(ofKeys keys: [K], andValueType valueType: Value.Type) throws -> [K: Value] where Value: Decodable {
    var data = [K: Value]()
    for key in keys {
       let result = try decode(Value.self, forKey: key)
       data[key] = result
    }
    return data
  }

  func decodeDictionary<Value>(withValueType valueType: Value.Type) throws -> [K: Value] where Value: Decodable {
    return try decodeDictionary(ofKeys: allKeys, andValueType: valueType)
  }

}
