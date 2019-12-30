import Foundation

public enum TransitionDataProviderInterceptorResult {
  case success
  case failure(_ error: Error)
  case `repeat`(_ request: URLRequest)
}
