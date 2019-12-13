import Foundation

public protocol TransitionDataProvider {
  func getTransitionData(forRequest request: URLRequest) -> TransitionDataProviderTask
}




