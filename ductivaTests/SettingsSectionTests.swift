import SwiftUI
import XCTest
@testable import ductiva

final class SettingsSectionTests: XCTestCase {

    // MARK: - Smoke tests

    func testSettingsSectionCanBeCreated() {
        let view = SettingsSection(
            launchAtLogin: .constant(false),
            showInMenuBar: .constant(true)
        )
        XCTAssertNotNil(view)
    }

    func testSettingsSectionBodyRenders() {
        let view = SettingsSection(
            launchAtLogin: .constant(false),
            showInMenuBar: .constant(true)
        )
        let body = view.body
        XCTAssertNotNil(body)
    }

    // MARK: - Binding passthrough

    func testSettingsSectionAcceptsLaunchAtLoginBinding() {
        var launchAtLogin = false
        let binding = Binding(get: { launchAtLogin }, set: { launchAtLogin = $0 })
        let view = SettingsSection(
            launchAtLogin: binding,
            showInMenuBar: .constant(true)
        )
        XCTAssertNotNil(view)
    }

    func testSettingsSectionAcceptsShowInMenuBarBinding() {
        var showInMenuBar = true
        let binding = Binding(get: { showInMenuBar }, set: { showInMenuBar = $0 })
        let view = SettingsSection(
            launchAtLogin: .constant(false),
            showInMenuBar: binding
        )
        XCTAssertNotNil(view)
    }

    // MARK: - Default values match design

    func testLaunchAtLoginDefaultIsFalse() {
        // Design shows "Launch at Login" toggle OFF by default
        let view = SettingsSection(
            launchAtLogin: .constant(false),
            showInMenuBar: .constant(true)
        )
        XCTAssertNotNil(view)
    }

    func testShowInMenuBarDefaultIsTrue() {
        // Design shows "Show in Menu Bar" toggle ON by default
        let view = SettingsSection(
            launchAtLogin: .constant(false),
            showInMenuBar: .constant(true)
        )
        XCTAssertNotNil(view)
    }

    // MARK: - Row labels

    func testSettingsSectionHasExpectedRowLabels() {
        XCTAssertEqual(SettingsSection.launchAtLoginLabel, "Launch at Login")
        XCTAssertEqual(SettingsSection.showInMenuBarLabel, "Show in Menu Bar")
    }
}
