import SwiftUI
import XCTest
@testable import ductiva

final class ActionBarTests: XCTestCase {

    // MARK: - Smoke tests

    func testActionBarCanBeCreated() {
        let bar = ActionBar(onCancel: {}, onSave: {})
        XCTAssertNotNil(bar)
    }

    func testActionBarBodyRenders() {
        let bar = ActionBar(onCancel: {}, onSave: {})
        let body = bar.body
        XCTAssertNotNil(body)
    }

    // MARK: - Callbacks

    func testActionBarCancelCallbackInvoked() {
        var cancelCalled = false
        let bar = ActionBar(onCancel: { cancelCalled = true }, onSave: {})
        bar.onCancel()
        XCTAssertTrue(cancelCalled)
    }

    func testActionBarSaveCallbackInvoked() {
        var saveCalled = false
        let bar = ActionBar(onCancel: {}, onSave: { saveCalled = true })
        bar.onSave()
        XCTAssertTrue(saveCalled)
    }

    // MARK: - Labels

    func testActionBarHasExpectedLabels() {
        XCTAssertEqual(ActionBar.cancelLabel, "CANCEL")
        XCTAssertEqual(ActionBar.saveLabel, "SAVE CHANGES")
    }

    // MARK: - Disabled state

    func testActionBarAcceptsIsDisabledParameter() {
        let bar = ActionBar(onCancel: {}, onSave: {}, isDisabled: true)
        XCTAssertTrue(bar.isDisabled)
    }

    func testActionBarIsDisabledDefaultsToFalse() {
        let bar = ActionBar(onCancel: {}, onSave: {})
        XCTAssertFalse(bar.isDisabled)
    }

    func testActionBarBodyRendersWhenDisabled() {
        let bar = ActionBar(onCancel: {}, onSave: {}, isDisabled: true)
        let body = bar.body
        XCTAssertNotNil(body)
    }
}
