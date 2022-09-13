import Foundation

public protocol TransitionDataProviderTask: AnyObject {

  var progress: Progress { get }

  var result: TransitionDataProviderResult { get }

  func await()

  func resume()

  func cancel()

  var isCancelled: Bool { get }

  var isFinished: Bool { get }

}
