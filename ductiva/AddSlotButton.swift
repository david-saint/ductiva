import SwiftUI

/// A dashed-border button for adding a new habit slot.
/// Styled to match the Stealth Ceramic design with hover effects.
struct AddSlotButton: View {
    var action: () -> Void

    static let label = "+ SLOT"
    static let dashPattern: [CGFloat] = [6, 4]

    @State private var isHovered = false

    var body: some View {
        Button {
            action()
        } label: {
            Text(Self.label)
                .font(.caption)
                .tracking(StealthCeramicTheme.counterTracking)
                .foregroundStyle(StealthCeramicTheme.secondaryTextColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background {
                    RoundedRectangle(cornerRadius: StealthCeramicTheme.surfaceCornerRadius, style: .continuous)
                        .fill(isHovered ? StealthCeramicTheme.surfaceHoverColor : .clear)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: StealthCeramicTheme.surfaceCornerRadius, style: .continuous)
                        .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: Self.dashPattern))
                        .foregroundStyle(isHovered ? StealthCeramicTheme.glassStrokeColor : StealthCeramicTheme.dashedBorderColor)
                }
                .contentShape(RoundedRectangle(cornerRadius: StealthCeramicTheme.surfaceCornerRadius, style: .continuous))
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.2), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}
