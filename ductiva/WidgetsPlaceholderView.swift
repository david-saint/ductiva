import SwiftUI

struct WidgetsPlaceholderView: View {
    var body: some View {
        ZStack {
            StealthCeramicTheme.chassisColor.ignoresSafeArea()
            VStack(spacing: 12) {
                Image(systemName: "square.grid.2x2")
                    .font(.largeTitle)
                    .foregroundStyle(StealthCeramicTheme.secondaryTextColor)
                Text("WIDGETS")
                    .font(.caption)
                    .tracking(4)
                    .foregroundStyle(StealthCeramicTheme.secondaryTextColor)
                Text("Coming soon")
                    .font(.caption2)
                    .foregroundStyle(StealthCeramicTheme.secondaryTextColor.opacity(0.6))
            }
        }
    }
}
