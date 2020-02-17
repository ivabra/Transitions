import Foundation
import Transitions_Core

public final class DataProviderTransitionContextImpl: TransitionContext & ProgressObservableTransitionContext & CancellableTransitionContext {

  private let jsonDecoder: JSONDecoder
  private let jsonEncoder: JSONEncoder

  private let dataProvider: TransitionDataProvider
  private let interceptor: TransitionDataProviderInterceptor?

  private(set) public var isCancelled: Bool = false
  private var currentTask: TransitionDataProviderTask?

  public let progress: Progress = Progress()
  public var progressPerTransition: Int64 = 100

  public init(dataProvider: TransitionDataProvider,
              jsonDecoder: JSONDecoder,
              jsonEncoder: JSONEncoder,
              interceptor: TransitionDataProviderInterceptor?) {
    self.dataProvider = dataProvider
    self.jsonDecoder = jsonDecoder
    self.jsonEncoder = jsonEncoder
    self.interceptor = interceptor
  }

  public func data(urlRequest request: URLRequest) throws -> (Data, URLResponse) {

    var currentRequest: URLRequest = request
    var finished = false
    var result: TransitionDataProviderResult

    repeat {
      let task = dataProvider.getTransitionData(forRequest: request)

      self.currentTask = task
      progress.addChild(task.progress, withPendingUnitCount: progressPerTransition)
      task.resume()
      task.await()

      currentTask = nil

      if task.isCancelled || isCancelled {
        throw TransitionResolutionError.cancelled
      }

      result = task.result

      switch interceptor?.interceptResult(&result, ofRequest: request) {
        case .pass?:
          finished = true
          break
        case .repeat(let request)?:
          progress.completedUnitCount -= task.progress.completedUnitCount
          currentRequest = request
        default:
          break
      }

    } while !finished

    if let error = result.error {
      throw error
    }

    if let response = result.response {
      return (result.data ?? Data(), response)
    } else {
      throw TransitionResolutionError.noResponse(currentRequest)
    }

  }

  public func cancel() {
    self.isCancelled = true
    currentTask?.cancel()
    progress.cancel()
  }

  public func encode<Content>(_ content: Content) throws -> Data where Content : Encodable {
    if isCancelled { throw TransitionResolutionError.cancelled }
    return try jsonEncoder.encode(content)
  }

  public func decode<Content>(_ type: Content.Type, from data: Data) throws -> Content where Content : Decodable {
    if isCancelled { throw TransitionResolutionError.cancelled }
    return try jsonDecoder.decode(type, from: data)
  }

}
