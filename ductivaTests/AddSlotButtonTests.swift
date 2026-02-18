import SwiftUI
import XCTest
@testable import ductiva

final class AddSlotButtonTests: XCTestCase {

    // MARK: - Smoke tests

    func testAddSlotButtonCanBeCreated() {
        let button = AddSlotButton(action: {})
        XCTAssertNotNil(button)
    }

    func testAddSlotButtonBodyRenders() {
        let button = AddSlotButton(action: {})
        let body = button.body
        XCTAssertNotNil(body)
    }

    // MARK: - Callback

    func testAddSlotButtonActionInvoked() {
        var actionCalled = false
        let button = AddSlotButton(action: { actionCalled = true })
        button.action()
        XCTAssertTrue(actionCalled)
    }

    // MARK: - Label

    func testAddSlotButtonHasExpectedLabel() {
        XCTAssertEqual(AddSlotButton.label, "+ SLOT")
    }

    // MARK: - Dash style

    func testAddSlotButtonDashPatternIsDefined() {
        let pattern = AddSlotButton.dashPattern
        XCTAssertEqual(pattern.count, 2, "Dash pattern should have dash and gap values")
        XCTAssertGreaterThan(pattern[0], 0)
        XCTAssertGreaterThan(pattern[1], 0)
    }
}
