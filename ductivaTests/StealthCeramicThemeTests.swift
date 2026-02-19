import XCTest
@testable import ductiva

final class StealthCeramicThemeTests: XCTestCase {
    func testChassisHexMatchesGuideline() {
        XCTAssertEqual(StealthCeramicTheme.chassisHex, "#1C1C1E")
    }

    func testGlassTokenUsesUltraThinMaterial() {
        XCTAssertEqual(StealthCeramicTheme.glassMaterialToken, "ultraThinMaterial")
    }

    func testSurfaceCornerRadiusIsPositive() {
        XCTAssertGreaterThan(StealthCeramicTheme.surfaceCornerRadius, 0)
    }

    // MARK: - Task 2.2: Stealth Ceramic styling constants

    func testDividerColorExists() {
        let color = StealthCeramicTheme.dividerColor
        XCTAssertNotNil(color)
    }

    func testDashedBorderColorExists() {
        let color = StealthCeramicTheme.dashedBorderColor
        XCTAssertNotNil(color)
    }

    func testHeaderTrackingValueIsPositive() {
        XCTAssertGreaterThan(StealthCeramicTheme.headerTracking, 0)
    }

    func testSlotCounterTrackingValueIsNonNegative() {
        XCTAssertGreaterThanOrEqual(StealthCeramicTheme.counterTracking, 0)
    }

    func testGlassMaterialReturnsValue() {
        let material = StealthCeramicTheme.glassMaterial
        XCTAssertNotNil(material)
    }

    func testSolidButtonColorsExist() {
        XCTAssertNotNil(StealthCeramicTheme.solidButtonBackground)
        XCTAssertNotNil(StealthCeramicTheme.solidButtonForeground)
    }

    func testToggleColorsExist() {
        XCTAssertNotNil(StealthCeramicTheme.toggleActiveColor)
        XCTAssertNotNil(StealthCeramicTheme.toggleInactiveColor)
        XCTAssertNotNil(StealthCeramicTheme.toggleKnobColor)
    }

    func testSurfaceColorsExist() {
        XCTAssertNotNil(StealthCeramicTheme.surfaceColor)
        XCTAssertNotNil(StealthCeramicTheme.surfaceHoverColor)
    }

    func testTextColorsExist() {
        XCTAssertNotNil(StealthCeramicTheme.primaryTextColor)
        XCTAssertNotNil(StealthCeramicTheme.secondaryTextColor)
    }
}
