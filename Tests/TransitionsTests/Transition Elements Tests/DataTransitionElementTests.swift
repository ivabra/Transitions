import XCTest
@testable import Transitions

final class DataTransitionElementTests: XCTestCase {

  func testDataTransitionElement() {

    let context = MockingContext()
    let url = URL(fileURLWithPath: "")

    let builder = JustURLRequestBuilder.builder
    let urlRequest = try! builder.request(for: url, context: context)

    let expectedData = Data([1,2,3,10])

    context.resultMap[urlRequest] = (expectedData, URLResponse())

    let element = DataTransitionElement(requestBuilder: builder, parentElement: transitionElement(of: url))
    let resultData = try! element.transitionResult(for: context)

    XCTAssertTrue(context.executedRequests.contains(urlRequest))
    XCTAssertTrue(expectedData == resultData)

  }

}


class MockingContext: FakeContext {

  var executedRequests = Set<URLRequest>()
  var resultMap = [URLRequest: (Data, URLResponse)]()

  override func data(urlRequest: URLRequest) throws -> (Data, URLResponse) {
    executedRequests.insert(urlRequest)
    return resultMap[urlRequest]!
  }

}

class FakeContext: TransitionContext {

   var progressPerTransition: Int64 = 0

   let progress: Progress = Progress()

   var isCancelled: Bool { false }

   func decode<Content>(_ type: Content.Type, from data: Data) throws -> Content where Content : Decodable {
     fatalError("Not implemented")
   }

   func encode<Content>(_ content: Content) throws -> Data where Content : Encodable {
     fatalError("NotImplemented")
   }

   func data(urlRequest: URLRequest) throws -> (Data, URLResponse) {
    fatalError("NotImplemented")
   }

   func cancel() {}

 }
