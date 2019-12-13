import Foundation

public final class TransitionContextImpl: TransitionContext & ProgressObservableTransitionContext & CancellableTransitionContext {

  private let jsonDecoder: JSONDecoder
  private let jsonEncoder: JSONEncoder

  private let dataProvider: TransitionDataProvider
  private let interceptor: TransitionDataProviderInterceptor?

  private(set) public var isCancelled: Bool = false
  private var currentTask: TransitionDataProviderTask?

  public let progress: Progress = Progress()
  public var progressPerTransition: Int64 = 100

  public init(dataProvider: TransitionDataProvider, jsonDecoder: JSONDecoder, jsonEncoder: JSONEncoder, interceptor: TransitionDataProviderInterceptor?) {
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

      switch interceptor?.investigateResult(result, ofRequest: request) {
      case .failure(let error)?:
        throw error
      case .repeat(let request)?:
        progress.completedUnitCount -= task.progress.completedUnitCount
        currentRequest = request
      case .success?, nil:
        finished = true
      }

    } while !finished


    if let error = result.error {
      throw error
    }

    if let data = result.data, let response = result.response {
      return (data, response)
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
    try jsonEncoder.encode(content)
  }

  public func decode<Content>(_ type: Content.Type, from data: Data) throws -> Content where Content : Decodable {
    try jsonDecoder.decode(type, from: data)
  }

}
