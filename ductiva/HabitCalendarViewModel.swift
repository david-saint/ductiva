import Foundation
import Observation

@Observable
final class HabitCalendarViewModel {
    let habit: Habit
    let calendar: Calendar
    let now: Date

    private(set) var displayedMonthStart: Date

    // Initialize streak service once
    private let streakService: HabitStreakService

    // Cache the snapshot to avoid recalculating on every access
    private var cachedSnapshot: HabitStreakSnapshot?
    private var lastCompletionsCount: Int = -1

    deinit {}

    init(habit: Habit, calendar: Calendar = .current, now: Date = Date()) {
        self.habit = habit
        var mondayStartCalendar = calendar
        mondayStartCalendar.firstWeekday = 2 // Monday
        self.calendar = mondayStartCalendar
        self.now = now
        self.streakService = HabitStreakService(calendar: mondayStartCalendar, now: now)

        let start = mondayStartCalendar.date(from: mondayStartCalendar.dateComponents([.year, .month], from: now))
        self.displayedMonthStart = start ?? mondayStartCalendar.startOfDay(for: now)
    }

    var monthTitle: String {
        displayedMonthStart.formatted(.dateTime.month(.wide).year())
    }

    var snapshot: HabitStreakSnapshot {
        if habit.completions.count != lastCompletionsCount || cachedSnapshot == nil {
            lastCompletionsCount = habit.completions.count
            cachedSnapshot = streakService.snapshot(for: habit)
        }
        return cachedSnapshot!
    }

    var dayStates: [HabitCalendarDayState] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: displayedMonthStart),
            let firstGridDate = calendar.dateInterval(of: .weekOfYear, for: monthInterval.start)?.start
        else {
            return []
        }

        let schedule = habit.schedule
        let normalizedDays = streakService.normalizedCompletionDays(for: habit)
        let currentMonth = calendar.component(.month, from: displayedMonthStart)
        let currentYear = calendar.component(.year, from: displayedMonthStart)

        return (0..<42).compactMap { offset in
            guard let day = calendar.date(byAdding: .day, value: offset, to: firstGridDate) else {
                return nil
            }
            
            let dayMonth = calendar.component(.month, from: day)
            let dayYear = calendar.component(.year, from: day)
            
            return HabitCalendarDayState(
                date: day,
                isInDisplayedMonth: currentMonth == dayMonth && currentYear == dayYear,
                isScheduled: streakService.isScheduled(on: day, schedule: schedule),
                isCompleted: streakService.isCompleted(on: day, completionDays: normalizedDays),
                isToday: calendar.isDate(day, inSameDayAs: now)
            )
        }
    }

    func showPreviousMonth() {
        moveMonth(by: -1)
    }

    func showNextMonth() {
        moveMonth(by: 1)
    }

    func state(for date: Date) -> HabitCalendarDayState {
        let schedule = habit.schedule
        let normalizedDays = streakService.normalizedCompletionDays(for: habit)
        let day = calendar.startOfDay(for: date)
        let currentMonth = calendar.component(.month, from: displayedMonthStart)
        let currentYear = calendar.component(.year, from: displayedMonthStart)
        let dayMonth = calendar.component(.month, from: day)
        let dayYear = calendar.component(.year, from: day)

        return HabitCalendarDayState(
            date: day,
            isInDisplayedMonth: currentMonth == dayMonth && currentYear == dayYear,
            isScheduled: streakService.isScheduled(on: day, schedule: schedule),
            isCompleted: streakService.isCompleted(on: day, completionDays: normalizedDays),
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
