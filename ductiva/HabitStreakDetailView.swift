import SwiftData
import SwiftUI

struct HabitStreakDetailView: View {
    @Bindable var habit: Habit
    @State private var calendarViewModel: HabitCalendarViewModel

    private let calendar: Calendar
    private let now: Date

    init(habit: Habit, calendar: Calendar = .current, now: Date = Date()) {
        self.habit = habit
        self.calendar = calendar
        self.now = now
        _calendarViewModel = State(initialValue: HabitCalendarViewModel(habit: habit, calendar: calendar, now: now))
    }

    var body: some View {
        ZStack {
            Rectangle()
                .fill(StealthCeramicTheme.chassisColor)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Text("HISTORY_LOG_V2.0")
                    .font(.system(size: 11, weight: .medium, design: .monospaced))
                    .tracking(StealthCeramicTheme.headerTracking)
                    .foregroundStyle(StealthCeramicTheme.secondaryTextColor.opacity(0.4))
                    .padding(.top, 10)

                Spacer().frame(height: 18)

                HabitCalendarGridView(
                    monthTitle: calendarViewModel.monthTitle,
                    dayStates: calendarViewModel.dayStates,
                    onShowPreviousMonth: { calendarViewModel.showPreviousMonth() },
                    onShowNextMonth: { calendarViewModel.showNextMonth() }
                )
                .frame(maxWidth: 360)
                .padding(.horizontal, 24)
                .padding(.bottom, 28)

                Rectangle()
                    .fill(StealthCeramicTheme.dividerColor)
                    .frame(height: 1)

                HabitMetricsView(snapshot: snapshot)
            }
            .padding(.bottom, 0)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("\(habit.name) streak details")
        .accessibilityHint("Shows monthly scheduled-day completion history and streak metrics")
    }

    private var snapshot: HabitStreakSnapshot {
        HabitStreakService(calendar: calendar, now: now).snapshot(for: habit)
    }
}
