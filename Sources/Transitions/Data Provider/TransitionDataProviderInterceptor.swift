import Foundation

public protocol TransitionDataProviderInterceptor {
  func interceptResult(_ result: inout TransitionDataProviderResult, ofRequest request: URLRequest) -> TransitionDataProviderInterceptorResult
}
