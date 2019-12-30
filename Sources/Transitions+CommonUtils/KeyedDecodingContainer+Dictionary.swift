

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

//extension Decoder {
//
//  func decodeDictionary<Key, Value>(ofKeys keys: [Key], andValuesOfType valueType: Value.Type) throws -> [Key: Value] where Key: Hashable & CodingKey, Value: Decodable {
//    let container = try self.container(keyedBy: keyType)
//    var data = [Key: Value]()
//    for key in keys {
//       let result = try container.decode(Value.self, forKey: key)
//       data[key] = result
//    }
//    return data
//  }
//
//  func decodeDictionary<Key, Value>(ofKeys keyType: Key.Type, andValuesOfType valueType: Value.Type) throws -> [Key: Value] where Key: Hashable & CodingKey, Value: Decodable {
//    let container = try self.container(keyedBy: keyType)
//    var data = [Key: Value]()
//    for key in container.allKeys {
//       let result = try container.decode(Value.self, forKey: key)
//       data[key] = result
//    }
//    return data
//  }
//
//}
