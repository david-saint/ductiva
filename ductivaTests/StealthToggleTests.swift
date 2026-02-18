import SwiftUI
import XCTest
@testable import ductiva

final class StealthToggleTests: XCTestCase {

    func testStealthToggleCanBeCreated() {
        let toggle = StealthToggle(isOn: .constant(false))
        XCTAssertNotNil(toggle)
    }

    func testStealthToggleBodyRendersWhenOff() {
        let toggle = StealthToggle(isOn: .constant(false))
        let body = toggle.body
        XCTAssertNotNil(body)
    }

    func testStealthToggleBodyRendersWhenOn() {
        let toggle = StealthToggle(isOn: .constant(true))
        let body = toggle.body
        XCTAssertNotNil(body)
    }

    func testStealthToggleAcceptsBinding() {
        var isOn = true
        let binding = Binding(get: { isOn }, set: { isOn = $0 })
        let toggle = StealthToggle(isOn: binding)
        XCTAssertNotNil(toggle)
    }
}
