import Foundation
import Transitions_Core

public struct CachePolicyURLRequestModifier<Parent: URLRequestBuilder>: URLRequestBuilder {

  public var parent: Parent
  public var cachePolicy: URLRequest.CachePolicy

  public var description: String {
    return "\(parent) & CachePolicy(\(cachePolicy))"
  }

  public init(cachePolicy: URLRequest.CachePolicy, parent: Parent) {
    self.parent = parent
    self.cachePolicy = cachePolicy
  }

  public func request(for url: URL, context: TransitionContext) throws -> URLRequest {
    var request = try parent.request(for: url, context: context)
    request.cachePolicy = cachePolicy
    return request
  }

}

public extension URLRequestBuilder {

  func cachePolicy(_ policy: URLRequest.CachePolicy) -> CachePolicyURLRequestModifier<Self> {
    CachePolicyURLRequestModifier(cachePolicy: policy, parent: self)
  }

}

extension URLRequest.CachePolicy: CustomStringConvertible {

  public var description: String {
    switch self {
      case .reloadIgnoringLocalAndRemoteCacheData:
        return "reloadIgnoringLocalAndRemoteCacheData"
      case .reloadIgnoringLocalCacheData:
        return "reloadIgnoringLocalCacheData"
      case .useProtocolCachePolicy:
        return "useProtocolCachePolicy"
      case .returnCacheDataElseLoad:
        return "returnCacheDataElseLoad"
      case .returnCacheDataDontLoad:
        return "returnCacheDataDontLoad"
      case .reloadRevalidatingCacheData:
        return "reloadRevalidatingCacheData"
      @unknown default:
        return "unknown"
    }
  }

}
