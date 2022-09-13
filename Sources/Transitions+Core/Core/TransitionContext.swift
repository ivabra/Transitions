import Foundation


//public protocol TransitionContext: class {
//
//  var progressPerTransition: Int64 { get set }
//
//  var progress: Progress { get }
//
//  var isCancelled: Bool { get }
//
//  func cancel()
//
//  func encode<Content: Encodable>(_ content: Content) throws -> Data
//
//  func decode<Content: Decodable>(_ type: Content.Type, from data: Data) throws -> Content
//
//  func data(urlRequest: URLRequest) throws -> (Data, URLResponse)
//}


public protocol ProgressObservableTransitionContext: AnyObject {

  var progressPerTransition: Int64 { get set }

  var progress: Progress { get }

}

public protocol CancellableTransitionContext: AnyObject {

  var isCancelled: Bool { get }

  func cancel()

}


public protocol EncodingTransitionContext {

  func encode<Content: Encodable>(_ content: Content) throws -> Data

}

public protocol DecodingTransitionContext {

  func decode<Content: Decodable>(_ type: Content.Type, from data: Data) throws -> Content

}

public protocol NetworkTransitionContext {

  func data(urlRequest: URLRequest) throws -> (Data, URLResponse)

}


public typealias CodingTransitionContext = EncodingTransitionContext & DecodingTransitionContext

public typealias TransitionContext = CodingTransitionContext & NetworkTransitionContext


