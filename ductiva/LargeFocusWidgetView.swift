import SwiftUI
import WidgetKit

/// A large widget view displaying a single habit's detailed calendar.
struct LargeFocusWidgetView: View {
    @Environment(\.widgetContentMargins) private var widgetContentMargins

    let habit: WidgetHabitSnapshot?
    let dayStates: [HabitCalendarDayState]?
    let monthTitle: String?
    let currentDate: Date
    
    var body: some View {
        if let habit = habit, let dayStates = dayStates, let monthTitle = monthTitle {
            VStack(alignment: .leading, spacing: 12) {
                // Header (Habit Info)
                HStack(spacing: 12) {
                    Image(systemName: habit.iconName)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(width: 24)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(habit.name)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.white)
                            .lineLimit(1)
                        
                        let scheduleStr = habit.schedule.localizedDescription
                        let completed = habit.completions.contains { completion in
                            Calendar.current.isDate(completion, inSameDayAs: Calendar.current.startOfDay(for: currentDate))
                        }
                        let timeOrStatus = habit.isScheduled(on: currentDate) ? (completed ? "Done" : timeLeft(from: currentDate)) : (completed ? "Done" : "Off Today")
                        Text("\(habit.currentStreak) \((habit.currentStreak == 1) ? "day" : "days") streak • \(scheduleStr) • \(timeOrStatus)")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(.white.opacity(0.6))
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 8)
                .padding(.top, 4)
                
                Divider()
                    .background(Color.white.opacity(0.1))
                
                // Calendar Grid
                HabitCalendarGridView(
                    monthTitle: monthTitle,
                    dayStates: dayStates,
                    onShowPreviousMonth: {},
                    onShowNextMonth: {}
                )
                .padding(.horizontal, 4)
                .padding(.bottom, 4)
                
                Spacer(minLength: 0)
            }
            .padding(12)
        } else {
            emptyState
        }
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
        VStack(spacing: 8) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 32, weight: .light))
                .foregroundStyle(Color.white.opacity(0.35))
            Text("NO HABIT SELECTED")
                .font(.system(size: 10, weight: .medium))
                .tracking(StealthCeramicTheme.headerTracking)
                .foregroundStyle(Color.white.opacity(0.35))
        }
    }
}
