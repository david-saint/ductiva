import SwiftUI
import WidgetKit

/// A small widget view focused on a single habit, showing a large completion ring,
/// the habit name, and schedule label. Used in `.systemSmall` when a specific habit
/// is selected via the widget's configuration intent.
///
/// Design reference: "SMALL WIDGET (FOCUS MODE)" from Widgets.png —
/// centered large ring with the habit icon inside, habit name in uppercase
/// monospaced below, and a subtle schedule descriptor.
struct SmallFocusWidgetView: View {
    let habit: WidgetHabitSnapshot?
    let currentDate: Date

    // MARK: - Computed Properties

    /// Whether the focused habit is completed on `currentDate`.
    var isHabitCompleted: Bool {
        guard let habit else { return false }
        let calendar = Calendar.current
        let targetDay = calendar.startOfDay(for: currentDate)
        return habit.completions.contains { completion in
            calendar.isDate(completion, inSameDayAs: targetDay)
        }
    }

    /// Ring progress for the focused habit (1.0 = full, 0.0 = depleted).
    var ringProgress: Double {
        guard let habit else { return 1.0 }
        return HabitCompletionRingView.ringProgress(
            schedule: habit.schedule,
            now: currentDate
        )
    }

    /// Schedule description for the label beneath the name.
    var scheduleLabel: String? {
        habit?.schedule.localizedDescription
    }

    // MARK: - Body

    var body: some View {
        if let habit {
            focusContent(habit)
        } else {
            emptyState
        }
    }

    // MARK: - Focus Content

    @ViewBuilder
    private func focusContent(_ habit: WidgetHabitSnapshot) -> some View {
        VStack(spacing: 8) {
            ZStack {
                WidgetCompletionRing(
                    progress: ringProgress,
                    isCompleted: isHabitCompleted,
                    ringSize: 64
                )

                Image(systemName: habit.iconName)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(
                        isHabitCompleted
                            ? Color.white
                            : Color.white.opacity(0.85)
                    )
            }

            VStack(spacing: 2) {
                Text(habit.name.uppercased())
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .tracking(1)
                    .foregroundStyle(Color.white.opacity(0.92))
                    .lineLimit(1)

                if let scheduleLabel {
                    Text(scheduleLabel)
                        .font(.system(size: 9, weight: .medium))
                        .foregroundStyle(Color.white.opacity(0.5))
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .widgetURL(WidgetDeepLink.habitURL(for: habit.id))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(habit.name), \(isHabitCompleted ? "completed" : "not completed")")
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 6) {
            Image(systemName: "target")
                .font(.system(size: 28, weight: .light))
                .foregroundStyle(Color.white.opacity(0.35))
            Text("SELECT HABIT")
                .font(.system(size: 9, weight: .medium, design: .monospaced))
                .tracking(1)
                .foregroundStyle(Color.white.opacity(0.35))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
