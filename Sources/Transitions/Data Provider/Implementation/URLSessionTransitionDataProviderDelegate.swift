import struct Foundation.URLRequest

public protocol URLSessionTransitionDataProviderDelegate: AnyObject {

  func urlSessionTransitionDataProvider(_ provider: URLSessionTransitionDataProvider, willPerformRequest  request: inout URLRequest) throws

}

public extension URLSessionTransitionDataProviderDelegate {

  func urlSessionTransitionDataProvider(_ provider: URLSessionTransitionDataProvider, willPerformRequest  request: inout URLRequest) throws {}

}
