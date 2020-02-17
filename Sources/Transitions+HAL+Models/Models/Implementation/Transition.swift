import Foundation

public struct Transition {

  public let links: [Link]

  public init(links: [Link]) {
    self.links = links
  }

  public struct Link: Codable {

    public let href: String

    private enum CodingKeys: String, CodingKey {
      case href
    }

    public init(href: String) {
      self.href = href
    }

    public init(url: URL) {
      self.init(href: url.absoluteString)
    }

    public func url(with parameters: [String: Any], allowedCharacters: CharacterSet) throws -> URL  {
      var urlString = href
      urlString.deleteHALTailParameters()
      var tailParameters = [String: Any]()
      for (name, value) in parameters {
        if let range = urlString.range(of: "{\(name)}") {
          urlString.replaceSubrange(range, with: "\(value)")
        } else {
          tailParameters[name] = value
        }
      }
      guard let url = URL(string: urlString) else {
        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [CodingKeys.href], debugDescription: "\(urlString) is not valid URL. Probably loss of parameters. Used parameters: \(parameters)"))
      }
      guard let parametrisedUrl = url.appendingUrlParameters(tailParameters, allowedCharacters: allowedCharacters) else {
        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [CodingKeys.href], debugDescription: "Coudn't add parameters \(tailParameters) to url \(url)."))
      }
      return parametrisedUrl
    }

    public func url() throws -> URL {
      var urlString = href
      urlString.deleteHALTailParameters()
      guard let url = URL(string: urlString) else {
        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [CodingKeys.href], debugDescription: "\(urlString) is not valid URL."))
      }
      return url
    }

  }

}

private extension String {

  mutating func deleteHALTailParameters() {
    if let start = range(of: "{?")?.lowerBound, let end = lastIndex(of: "}") {
       removeSubrange(start...end)
    }
  }

}

public extension Transition {

  init(link: Link) {
    self.links = [link]
  }

  init(url: URL) {
    self.links = [Link(url: url)]
  }

}

extension Transition: Codable {

  public init(from decoder: Decoder) throws {
     var links = [Link]()
     var notArray = false
     do {
       var container = try decoder.unkeyedContainer()
       repeat {
          let link = try container.decode(Link.self)
          links.append(link)
       } while (!container.isAtEnd)
     } catch {
        notArray = true
     }
     if notArray {
      do {
        let singleContainer = try decoder.singleValueContainer()
        let link = try singleContainer.decode(Link.self)
        links.append(link)
      } catch {}
     }
     self.links = links
   }

  public func encode(to encoder: Encoder) throws {
     if links.count == 1, let first = links.first {
       var container = encoder.singleValueContainer()
       try container.encode(first)
     } else if links.isEmpty == false {
       var container = encoder.unkeyedContainer()
       try container.encode(contentsOf: links)
     }
   }

}


public extension Transition {

  func firstUrl() throws -> URL? { try links.first?.url() }

  /// Means it has at least one link inside
  var isValid: Bool {
    (try? links.first?.url()) != nil
  }

}
