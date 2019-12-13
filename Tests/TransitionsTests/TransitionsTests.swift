import XCTest
import Foundation

@testable import Transitions


final class TransitionsTests: XCTestCase {

  struct FakeDataProvider: TransitionDataProvider {

    var resultMap: [URL: Data] = [:]

    func getTransitionData(forRequest request: URLRequest) -> TransitionDataProviderTask {
      let result = resultMap[request.url!] ?? Data()
      return Task(data: result)
    }

    class Task: TransitionDataProviderTask {

      let data: Data

      var result: TransitionDataProviderResult {
        return .init(data: data, response: URLResponse(), error: nil)
      }

      init(data: Data) {
        self.data = data
      }

      var progress: Progress = Progress()

      func await() {}

      func resume() {}

      func cancel() {}

      var isCancelled: Bool = false

      var isFinished: Bool = true

    }

  }

  var context = 0


  // TODO: Tests

  func exampleTest() {

  }

  static var allTests = [
      ("exampleTest", exampleTest)
  ]

  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    guard context == &self.context else {
      super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
      return
    }
    print(#function, change?[NSKeyValueChangeKey.newKey] as? Double ?? 0.0)
  }

}

struct TestUser: Decodable {

  let firstName: String
  let secondName: String

  let _links: Links<LinkKeys>

  enum LinkKeys: CodingKey {
    case `self`
    case user
  }

}

public struct TestRoot: Codable {

  public var _links: Links<LinkKeys>?

  public enum LinkKeys: String, CodingKey {
    case oauth2Token = "http://rels.goabout.com/oauth2-token"
    case geocoder = "http://rels.goabout.com/geocoder"
    case plan = "http://rels.goabout.com/plan"
    case orderInfo = "http://rels.goabout.com/order-info"
    case orderCheckout = "http://rels.goabout.com/order-checkout"
    case feedback = "http://rels.goabout.com/feedback"
  }

}
