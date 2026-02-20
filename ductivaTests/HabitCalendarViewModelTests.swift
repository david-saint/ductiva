import Foundation
import XCTest
@testable import ductiva

final class HabitCalendarViewModelTests: XCTestCase {
    func testMonthNavigationMovesBetweenAdjacentMonths() {
        let calendar = Self.gregorianCalendar
        let habit = Habit(
            name: "Read",
            createdAt: Self.date(year: 2026, month: 1, day: 1),
            schedule: .daily
        )
        let viewModel = HabitCalendarViewModel(
            habit: habit,
            calendar: calendar,
            now: Self.date(year: 2026, month: 2, day: 19)
        )

        viewModel.showPreviousMonth()
        XCTAssertTrue(
            calendar.isDate(viewModel.displayedMonthStart, equalTo: Self.date(year: 2026, month: 1, day: 1), toGranularity: .day)
        )

        viewModel.showNextMonth()
        XCTAssertTrue(
            calendar.isDate(viewModel.displayedMonthStart, equalTo: Self.date(year: 2026, month: 2, day: 1), toGranularity: .day)
        )
    }

    func testSpecificDayScheduleIdentifiesOnlyConfiguredWeekdaysAsScheduled() {
        let calendar = Self.gregorianCalendar
        let habit = Habit(
            name: "Workout",
            createdAt: Self.date(year: 2026, month: 2, day: 1),
            schedule: .specificDays([.monday, .wednesday, .friday]),
            completions: []
        )
        let viewModel = HabitCalendarViewModel(
            habit: habit,
            calendar: calendar,
            now: Self.date(year: 2026, month: 2, day: 19)
        )

        let mondayState = viewModel.state(for: Self.date(year: 2026, month: 2, day: 16))
        let tuesdayState = viewModel.state(for: Self.date(year: 2026, month: 2, day: 17))

        XCTAssertTrue(mondayState.isScheduled)
        XCTAssertFalse(tuesdayState.isScheduled)
    }

    func testDayStateMarksTodayOnlyForCurrentDate() {
        let calendar = Self.gregorianCalendar
        let now = Self.date(year: 2026, month: 2, day: 19)
        let habit = Habit(name: "Read", createdAt: Self.date(year: 2026, month: 1, day: 1), schedule: .daily)
        let viewModel = HabitCalendarViewModel(habit: habit, calendar: calendar, now: now)

        let todayState = viewModel.state(for: now)
        let otherDayState = viewModel.state(for: Self.date(year: 2026, month: 2, day: 18))

        XCTAssertTrue(todayState.isToday)
        XCTAssertFalse(otherDayState.isToday)
    }

    func testMonthlyGridMarksNonScheduledDaysAsNotScheduled() {
        let calendar = Self.gregorianCalendar
        let habit = Habit(
            name: "Workout",
            createdAt: Self.date(year: 2026, month: 2, day: 1),
            schedule: .specificDays([.monday, .wednesday, .friday])
        )
        let viewModel = HabitCalendarViewModel(
            habit: habit,
            calendar: calendar,
            now: Self.date(year: 2026, month: 2, day: 19)
        )

        let monday = Self.date(year: 2026, month: 2, day: 16)
        let tuesday = Self.date(year: 2026, month: 2, day: 17)
        let mondayState = viewModel.dayStates.first(where: { calendar.isDate($0.date, inSameDayAs: monday) })
        let tuesdayState = viewModel.dayStates.first(where: { calendar.isDate($0.date, inSameDayAs: tuesday) })

        XCTAssertNotNil(mondayState)
        XCTAssertNotNil(tuesdayState)
        XCTAssertTrue(mondayState?.isScheduled == true)
        XCTAssertFalse(tuesdayState?.isScheduled == true)
    }

    func testStateForDateInSameMonthDifferentYearIsNotInDisplayedMonth() {
        let calendar = Self.gregorianCalendar
        let habit = Habit(name: "Read", createdAt: Self.date(year: 2025, month: 1, day: 1), schedule: .daily)
        let viewModel = HabitCalendarViewModel(
            habit: habit,
            calendar: calendar,
            now: Self.date(year: 2026, month: 1, day: 15)
        )

        let sameMonthDifferentYear = Self.date(year: 2025, month: 1, day: 10)
        let state = viewModel.state(for: sameMonthDifferentYear)

        XCTAssertFalse(state.isInDisplayedMonth)
    }

    func testSnapshotUpdatesWhenScheduleChangesWithoutCompletionCountChange() {
        let calendar = Self.gregorianCalendar
        let now = Self.date(year: 2026, month: 2, day: 20)
        let completions = [
            Self.date(year: 2026, month: 2, day: 19),
            Self.date(year: 2026, month: 2, day: 20),
        ]
        let habit = Habit(
            name: "Read",
            createdAt: Self.date(year: 2026, month: 2, day: 1),
            schedule: .daily,
            completions: completions
        )
        let viewModel = HabitCalendarViewModel(habit: habit, calendar: calendar, now: now)

        XCTAssertEqual(viewModel.snapshot.currentStreak, 2)

        habit.schedule = .weekly
        XCTAssertEqual(viewModel.snapshot.currentStreak, 1)
    }

    func testSnapshotUpdatesWhenCompletionContentChangesWithSameCount() {
        let calendar = Self.gregorianCalendar
        let now = Self.date(year: 2026, month: 2, day: 20)
        let habit = Habit(
            name: "Read",
            createdAt: Self.date(year: 2026, month: 2, day: 1),
            schedule: .daily,
            completions: [Self.date(year: 2026, month: 2, day: 19)]
        )
        let viewModel = HabitCalendarViewModel(habit: habit, calendar: calendar, now: now)

        XCTAssertEqual(viewModel.snapshot.currentStreak, 1)

        habit.completions = [Self.date(year: 2026, month: 2, day: 18)]
        XCTAssertEqual(viewModel.snapshot.currentStreak, 0)
    }

    private static var gregorianCalendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }

    private static func date(year: Int, month: Int, day: Int) -> Date {
        let components = DateComponents(
            calendar: gregorianCalendar,
            timeZone: gregorianCalendar.timeZone,
            year: year,
            month: month,
            day: day,
            hour: 12
        )
        return components.date!
    }
}
