import SwiftUI

enum StealthCeramicTheme {
    static let chassisHex = "#1C1C1E"
    static let glassMaterialToken = "ultraThinMaterial"
    static let surfaceCornerRadius: CGFloat = 14

    static let chassisColor = Color(
        red: 28.0 / 255.0,
        green: 28.0 / 255.0,
        blue: 30.0 / 255.0
    )
    static let primaryTextColor = Color.white.opacity(0.92)
    static let secondaryTextColor = Color.white.opacity(0.72)
    static let glassStrokeColor = Color.white.opacity(0.18)

    static var glassMaterial: Material { .ultraThinMaterial }
}
