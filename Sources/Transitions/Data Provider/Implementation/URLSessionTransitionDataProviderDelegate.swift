import struct Foundation.URLRequest

public protocol URLSessionTransitionDataProviderDelegate: class {

  func urlSessionTransitionDataProvider(_ provider: URLSessionTransitionDataProvider, willPerformRequest  request: inout URLRequest) throws

}

public extension URLSessionTransitionDataProviderDelegate {

  func urlSessionTransitionDataProvider(_ provider: URLSessionTransitionDataProvider, willPerformRequest  request: inout URLRequest) throws {}

}
