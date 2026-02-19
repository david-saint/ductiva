import SwiftUI
import WidgetKit

/// A large standard widget displaying up to 8 habits.
struct LargeStandardWidgetView: View {
    @Environment(\.widgetContentMargins) private var widgetContentMargins

    let habits: [WidgetHabitSnapshot]
    let currentDate: Date
    private let ringSize: CGFloat = 28
    
    var displayedHabits: [WidgetHabitSnapshot] {
        Array(habits.prefix(8))
    }
    
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
                    Link(destination: URL(string: "ductiva://habit/\(habit.id.uuidString)")!) {
                        habitRow(habit)
                    }
                    .buttonStyle(.plain)
                    
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
                
                let scheduleStr = habit.schedule.localizedDescription
                let timeOrStatus = habit.isScheduled(on: currentDate) ? (completed ? "Done" : timeLeft(from: currentDate)) : (completed ? "Done" : "Off Today")
                Text("\(habit.currentStreak) \((habit.currentStreak == 1) ? "day" : "days") streak • \(scheduleStr) • \(timeOrStatus)")
                    .font(.system(size: 10, weight: .regular))
                    .foregroundStyle(.white.opacity(0.5))
            }
            Spacer()
            WidgetCompletionRing(
                progress: HabitCompletionRingView.ringProgress(schedule: habit.schedule, now: currentDate),
                isCompleted: completed,
                ringSize: ringSize,
                lineWidth: 3
            )
        }
        .padding(.vertical, 12)
    }
    
    // MARK: - Helpers
    
    private func timeLeft(from date: Date) -> String {
        let calendar = Calendar.current
        guard let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 0, of: date) else {
            return ""
        }
        let components = calendar.dateComponents([.hour, .minute], from: date, to: endOfDay)
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        
        if hours > 0 {
            return "\(hours)hr, \(minutes)m"
        } else {
            return "\(minutes)m"
        }
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
