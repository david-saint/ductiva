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
}
