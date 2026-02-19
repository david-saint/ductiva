import SwiftUI
import WidgetKit

/// A 4x2 summary widget view displaying up to 4 habits.
/// Each habit row shows the habit icon, name, current streak, and completion ring.
struct MediumSummaryWidgetView: View {
    @Environment(\.widgetContentMargins) private var widgetContentMargins

    let habits: [WidgetHabitSnapshot]
    let currentDate: Date
    private let ringSize: CGFloat = 28
    
    /// The habits actually rendered (capped at 4).
    var displayedHabits: [WidgetHabitSnapshot] {
        Array(habits.prefix(4))
    }
    
    /// Whether a habit has a completion logged for `currentDate`.
    func isCompleted(_ habit: WidgetHabitSnapshot) -> Bool {
        let calendar = Calendar.current
        let targetDay = calendar.startOfDay(for: currentDate)
        return habit.completions.contains { completion in
            calendar.isDate(completion, inSameDayAs: targetDay)
        }
    }
    
    var body: some View {
        if displayedHabits.isEmpty {
            emptyState
        } else {
            VStack(spacing: 0) {
                ForEach(displayedHabits) { habit in
                    habitRow(habit)
                    if habit.id != displayedHabits.last?.id {
                        Divider()
                            .background(Color.white.opacity(0.1))
                    }
                }
                Spacer(minLength: 0)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
        }
    }
    
    @ViewBuilder
    private func habitRow(_ habit: WidgetHabitSnapshot) -> some View {
        let completed = isCompleted(habit)
        
        HStack(spacing: 12) {
            Image(systemName: habit.iconName)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(completed ? .white : .white.opacity(0.6))
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(habit.name)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(completed ? .white : .white.opacity(0.8))
                    .lineLimit(1)
                
                Text("\(habit.currentStreak) \((habit.currentStreak == 1) ? "day" : "days")")
                    .font(.system(size: 10, weight: .regular))
                    .foregroundStyle(.white.opacity(0.5))
            }
            
            Spacer()
            
            WidgetCompletionRing(
                progress: HabitCompletionRingView.ringProgress(
                    schedule: habit.schedule,
                    now: currentDate
                ),
                isCompleted: completed,
                ringSize: ringSize,
                lineWidth: 3
            )
        }
        .padding(.vertical, 6)
    }
    
    private var emptyState: some View {
        VStack(spacing: 6) {
            Image(systemName: "plus.circle.dashed")
                .font(.system(size: 24, weight: .light))
                .foregroundStyle(Color.white.opacity(0.35))
            Text("NO HABITS")
                .font(.system(size: 9, weight: .medium))
                .tracking(StealthCeramicTheme.headerTracking)
                .foregroundStyle(Color.white.opacity(0.35))
        }
    }
}
