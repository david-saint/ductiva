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
    
    // MARK: - Body

    var body: some View {
        if displayedHabits.isEmpty {
            emptyState
        } else {
            HStack(spacing: 0) {
                let slots = habitSlots
                slotCell(slots[0])
                slotCell(slots[1])
                slotCell(slots[2])
                slotCell(slots[3])
            }
            .padding(4)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private var habitSlots: [WidgetHabitSnapshot?] {
        var slots = displayedHabits.map(Optional.some)
        while slots.count < 4 {
            slots.append(nil)
        }
        return slots
    }

    @ViewBuilder
    private func slotCell(_ habit: WidgetHabitSnapshot?) -> some View {
        if let habit {
            Link(destination: URL(string: "ductiva://habit/\(habit.id.uuidString)")!) {
                habitCell(habit)
            }
        } else {
            Color.clear
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .accessibilityHidden(true)
        }
    }

    @ViewBuilder
    private func habitCell(_ habit: WidgetHabitSnapshot) -> some View {
        let completed = isCompleted(habit)

        VStack(spacing: 12) {
            ZStack {
                // Completion ring
                WidgetCompletionRing(
                    progress: HabitCompletionRingView.ringProgress(
                        schedule: habit.schedule,
                        now: currentDate
                    ),
                    isCompleted: completed,
                    ringSize: 54 // slightly reduced to fit text
                )

                // Habit icon
                Image(systemName: habit.iconName)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(
                        completed
                            ? Color.white
                            : Color.white.opacity(0.7)
                    )
            }
            
            let timeOrStatus = habit.isScheduled(on: currentDate) ? (completed ? "Done" : timeLeft(from: currentDate)) : (completed ? "Done" : "Off Today")
            Text(timeOrStatus)
                .font(.system(size: 10, weight: .regular))
                .foregroundStyle(Color.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(habit.name), \(completed ? "completed" : "not completed")")
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
    
    // MARK: - Empty State
    
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
