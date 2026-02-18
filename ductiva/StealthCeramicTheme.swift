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
    static let dividerColor = Color.white.opacity(0.12)
    static let dashedBorderColor = Color.white.opacity(0.28)

    // MARK: - Typography

    static let headerTracking: CGFloat = 4
    static let counterTracking: CGFloat = 2

    // MARK: - Materials

    static var glassMaterial: Material { .ultraThinMaterial }
}
