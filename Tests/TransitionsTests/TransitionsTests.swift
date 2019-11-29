import XCTest
@testable import Transitions

final class TransitionsTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Transitions().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
