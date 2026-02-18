import SwiftUI

/// A single habit row displaying the icon and name.
/// Flat by default; glass material appears on hover for interactive feedback.
struct HabitSlotRow: View {
    let habit: Habit

    @State private var isHovered = false

    var body: some View {
        rowContent
            .background {
                RoundedRectangle(cornerRadius: StealthCeramicTheme.surfaceCornerRadius, style: .continuous)
                    .fill(StealthCeramicTheme.glassMaterial)
                    .opacity(isHovered ? 1 : 0)
            }
            .overlay {
                RoundedRectangle(cornerRadius: StealthCeramicTheme.surfaceCornerRadius, style: .continuous)
                    .stroke(StealthCeramicTheme.glassStrokeColor, lineWidth: 1)
                    .opacity(isHovered ? 1 : 0)
            }
            .animation(.easeInOut(duration: 0.2), value: isHovered)
            .onHover { hovering in
                isHovered = hovering
            }
    }

    private var rowContent: some View {
        HStack(spacing: 16) {
            Image(systemName: habit.iconName)
                .font(.system(size: 18))
                .foregroundStyle(StealthCeramicTheme.secondaryTextColor)
                .frame(width: 28)
            Text(habit.name)
                .foregroundStyle(StealthCeramicTheme.primaryTextColor)
            Spacer()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }
}
