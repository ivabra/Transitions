import Foundation

public enum TransitionDataProviderInterceptorResult {
  case pass
  case `repeat`(_ request: URLRequest)
}
