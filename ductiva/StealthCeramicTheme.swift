import SwiftUI

enum StealthCeramicTheme {
    static let chassisHex = "#141416"
    static let glassMaterialToken = "ultraThinMaterial"
    static let surfaceCornerRadius: CGFloat = 8

    // Darker, richer background matching the target design
    static let chassisColor = Color(
        red: 20.0 / 255.0,
        green: 20.0 / 255.0,
        blue: 22.0 / 255.0
    )

    // Subtle elevated surface for rows
    static let surfaceColor = Color.white.opacity(0.06)
    static let surfaceHoverColor = Color.white.opacity(0.10)

    static let primaryTextColor = Color.white.opacity(0.92)
    static let secondaryTextColor = Color.white.opacity(0.50)
    static let glassStrokeColor = Color.white.opacity(0.10)
    static let dividerColor = Color.white.opacity(0.08)
    static let dashedBorderColor = Color.white.opacity(0.18)

    // Action button colors
    static let solidButtonBackground = Color.white.opacity(0.92)
    static let solidButtonForeground = Color.black

    // Toggle colors
    static let toggleActiveColor = Color.white.opacity(0.92)
    static let toggleInactiveColor = Color.white.opacity(0.15)
    static let toggleKnobColor = Color.white

    // MARK: - Typography

    static let headerTracking: CGFloat = 1
    static let counterTracking: CGFloat = 0

    // MARK: - Materials

    static var glassMaterial: Material { .ultraThinMaterial }
}
