import Foundation

struct HabitCalendarDayState: Identifiable {
    let date: Date
    let isInDisplayedMonth: Bool
    let isScheduled: Bool
    let isCompleted: Bool
    let isToday: Bool

    var id: Date { date }
}

final class HabitCalendarViewModel {
    let habit: Habit
    let calendar: Calendar
    let now: Date

    private(set) var displayedMonthStart: Date

    private var streakService: HabitStreakService {
        HabitStreakService(calendar: calendar, now: now)
    }

    deinit {}

    init(habit: Habit, calendar: Calendar = .current, now: Date = Date()) {
        self.habit = habit
        self.calendar = calendar
        self.now = now

        let start = calendar.date(from: calendar.dateComponents([.year, .month], from: now))
        self.displayedMonthStart = start ?? calendar.startOfDay(for: now)
    }

    var monthTitle: String {
        displayedMonthStart.formatted(.dateTime.month(.wide).year())
    }

    var dayStates: [HabitCalendarDayState] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: displayedMonthStart),
            let firstGridDate = calendar.dateInterval(of: .weekOfYear, for: monthInterval.start)?.start
        else {
            return []
        }

        return (0..<42).compactMap { offset in
            guard let day = calendar.date(byAdding: .day, value: offset, to: firstGridDate) else {
                return nil
            }
            return state(for: day)
        }
    }

    func showPreviousMonth() {
        moveMonth(by: -1)
    }

    func showNextMonth() {
        moveMonth(by: 1)
    }

    func state(for date: Date) -> HabitCalendarDayState {
        let day = calendar.startOfDay(for: date)
        let currentMonth = calendar.component(.month, from: displayedMonthStart)
        let currentYear = calendar.component(.year, from: displayedMonthStart)
        let dayMonth = calendar.component(.month, from: day)
        let dayYear = calendar.component(.year, from: day)

        return HabitCalendarDayState(
            date: day,
            isInDisplayedMonth: currentMonth == dayMonth && currentYear == dayYear,
            isScheduled: streakService.isScheduled(on: day, for: habit),
            isCompleted: streakService.isCompleted(on: day, for: habit),
            isToday: calendar.isDate(day, inSameDayAs: now)
        )
    }

    private func moveMonth(by offset: Int) {
        guard let next = calendar.date(byAdding: .month, value: offset, to: displayedMonthStart) else {
            return
        }

        displayedMonthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: next)) ?? next
    }
}
