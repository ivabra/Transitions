import Foundation

public enum TransitionDataProviderInterceptorResult {
  case success
  case update(_ result: TransitionDataProviderResult)
  case failure(_ error: Error)
  case `repeat`(_ request: URLRequest)
}
