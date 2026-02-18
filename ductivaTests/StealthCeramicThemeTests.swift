import XCTest
@testable import ductiva

final class StealthCeramicThemeTests: XCTestCase {
    func testChassisHexMatchesGuideline() {
        XCTAssertEqual(StealthCeramicTheme.chassisHex, "#1C1C1E")
    }

    func testGlassTokenUsesUltraThinMaterial() {
        XCTAssertEqual(StealthCeramicTheme.glassMaterialToken, "ultraThinMaterial")
    }

    func testSurfaceCornerRadiusSupportsGlassLayering() {
        XCTAssertGreaterThanOrEqual(StealthCeramicTheme.surfaceCornerRadius, 12)
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

    func testSlotCounterTrackingValueIsPositive() {
        XCTAssertGreaterThan(StealthCeramicTheme.counterTracking, 0)
    }
}
