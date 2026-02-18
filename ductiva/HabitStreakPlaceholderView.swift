import SwiftUI

struct HabitStreakPlaceholderView: View {
    let habit: Habit

    var body: some View {
        ZStack {
            StealthCeramicTheme.chassisColor.ignoresSafeArea()
            VStack(spacing: 12) {
                Image(systemName: habit.iconName)
                    .font(.largeTitle)
                    .foregroundStyle(StealthCeramicTheme.secondaryTextColor)
                Text(habit.name.uppercased())
                    .font(.caption)
                    .tracking(4)
                    .foregroundStyle(StealthCeramicTheme.primaryTextColor)
                Text("Streak detail coming soon")
                    .font(.caption2)
                    .foregroundStyle(StealthCeramicTheme.secondaryTextColor.opacity(0.6))
            }
        }
    }
}
