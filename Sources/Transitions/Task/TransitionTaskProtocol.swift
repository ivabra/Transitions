import Foundation

public protocol TransitionTaskProtocol: class {

  associatedtype TaskResult

  var isCancelled: Bool { get }

  var progress: Progress { get }

  func getResult() throws -> TaskResult

  func cancel()

}




