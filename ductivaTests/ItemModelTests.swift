import Foundation
import XCTest
@testable import ductiva

final class ItemModelTests: XCTestCase {
    func testItemInitializesWithTimestamp() {
        let timestamp = Date(timeIntervalSince1970: 1_700_000_000)
        let item = Item(timestamp: timestamp)

        XCTAssertEqual(item.timestamp, timestamp)
    }
}
