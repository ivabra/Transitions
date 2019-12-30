import Foundation

public protocol TransitionDataProviderInterceptor {
  func investigateResult(_ result: TransitionDataProviderResult, ofRequest request: URLRequest) -> TransitionDataProviderInterceptorResult
}
