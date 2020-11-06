


import class Foundation.JSONDecoder
import class Foundation.JSONEncoder

open class TransitionTaskFactoryImpl: TransitionTaskFactory {

  public let dataProvider: TransitionDataProvider
  public let jsonDecoder: JSONDecoder
  public let jsonEncoder: JSONEncoder
  public let interceptor: TransitionDataProviderInterceptor?

  public init(dataProvider: TransitionDataProvider,
              decoder: JSONDecoder = .init(),
              encoder: JSONEncoder = .init(),
              interceptor: TransitionDataProviderInterceptor? = nil) {
    self.dataProvider = dataProvider
    self.interceptor = interceptor
    self.jsonDecoder = decoder
    self.jsonEncoder = encoder
  }

  open func task<Element>(for path: Element) -> TransitionTask<Element.TransitionResult> where Element: TransitionElement {
    let context = DataProviderTransitionContextImpl(dataProvider: dataProvider,
                                        jsonDecoder: jsonDecoder,
                                        jsonEncoder: jsonEncoder,
                                        interceptor: interceptor)
    let task = ConcreteTransitionTask(path: path, context: context)
    return task
  }

}
