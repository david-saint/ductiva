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
                    .fill(isHovered ? StealthCeramicTheme.surfaceHoverColor : StealthCeramicTheme.surfaceColor)
            }
            .animation(.easeInOut(duration: 0.2), value: isHovered)
            .onHover { hovering in
                isHovered = hovering
            }
    }

    private var rowContent: some View {
        HStack(spacing: 14) {
            Image(systemName: habit.iconName)
                .font(.system(size: 16))
                .foregroundStyle(StealthCeramicTheme.secondaryTextColor)
                .frame(width: 24)
            Text(habit.name)
                .font(.system(size: 13))
                .foregroundStyle(StealthCeramicTheme.primaryTextColor)
            Spacer()
        }
        .padding(.vertical, 11)
        .padding(.horizontal, 14)
    }
}
