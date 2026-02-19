import Foundation
import XCTest
@testable import ductiva

final class HabitCalendarViewTests: XCTestCase {
    func testHabitCalendarGridViewCanBeCreated() {
        let states: [HabitCalendarDayState] = [
            HabitCalendarDayState(
                date: Self.date(year: 2026, month: 2, day: 18),
                isInDisplayedMonth: true,
                isScheduled: true,
                isCompleted: false,
                isToday: false
            )
        ]

        let view = HabitCalendarGridView(
            monthTitle: "February 2026",
            dayStates: states,
            onShowPreviousMonth: {},
            onShowNextMonth: {}
        )

        XCTAssertNotNil(view)
        _ = view.body
    }

    func testHabitMetricsViewCanBeCreated() {
        let snapshot = HabitStreakSnapshot(currentStreak: 6, perfectDays: 21, fireVisualActive: true)
        let view = HabitMetricsView(snapshot: snapshot)

        XCTAssertNotNil(view)
        _ = view.body
    }

    func testHabitStreakDetailViewCanBeCreated() {
        let habit = Habit(
            name: "Deep Work",
            iconName: "display",
            createdAt: Self.date(year: 2026, month: 1, day: 1),
            schedule: .specificDays([.monday, .wednesday, .friday]),
            completions: [Self.date(year: 2026, month: 2, day: 18)]
        )
        let view = HabitStreakDetailView(
            habit: habit,
            calendar: Self.gregorianCalendar,
            now: Self.date(year: 2026, month: 2, day: 19)
        )

        XCTAssertEqual(view.habit.name, "Deep Work")
        _ = view.body
    }

    private static var gregorianCalendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }

    private static func date(year: Int, month: Int, day: Int) -> Date {
        DateComponents(
            calendar: gregorianCalendar,
            timeZone: gregorianCalendar.timeZone,
            year: year,
            month: month,
            day: day,
            hour: 12
        ).date!
    }
}
