import SwiftUI

/// A single habit row displaying the icon and name.
/// Designed as a flat row that receives glass styling on hover (Phase 2.3).
struct HabitSlotRow: View {
    let habit: Habit

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: habit.iconName)
                .foregroundStyle(StealthCeramicTheme.secondaryTextColor)
                .frame(width: 24)
            Text(habit.name)
                .foregroundStyle(StealthCeramicTheme.primaryTextColor)
            Spacer()
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
    }
}
