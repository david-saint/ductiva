import Foundation
import XCTest
@testable import ductiva

final class HabitStreakServiceTests: XCTestCase {
    func testDailyHabitCountsCurrentStreakThroughYesterday() {
        let calendar = Self.gregorianCalendar
        let now = Self.date(year: 2026, month: 2, day: 19)
        let completions = [
            Self.date(year: 2026, month: 2, day: 16),
            Self.date(year: 2026, month: 2, day: 17),
            Self.date(year: 2026, month: 2, day: 18),
        ]
        let habit = Habit(
            name: "Deep Work",
            createdAt: Self.date(year: 2026, month: 2, day: 1),
            schedule: .daily,
            completions: completions
        )
        let service = HabitStreakService(calendar: calendar, now: now)

        let snapshot = service.snapshot(for: habit)

        XCTAssertEqual(snapshot.currentStreak, 3)
        XCTAssertEqual(snapshot.perfectDays, 3)
    }

    func testDailyHabitResetsStreakAfterMissedScheduledDay() {
        let calendar = Self.gregorianCalendar
        let now = Self.date(year: 2026, month: 2, day: 19)
        let completions = [
            Self.date(year: 2026, month: 2, day: 15),
            Self.date(year: 2026, month: 2, day: 16),
        ]
        let habit = Habit(
            name: "Read",
            createdAt: Self.date(year: 2026, month: 2, day: 1),
            schedule: .daily,
            completions: completions
        )
        let service = HabitStreakService(calendar: calendar, now: now)

        let snapshot = service.snapshot(for: habit)

        XCTAssertEqual(snapshot.currentStreak, 0)
        XCTAssertEqual(snapshot.perfectDays, 2)
    }

    func testWeeklyHabitCountsOneCompletionPerWeekRegardlessOfWeekday() {
        let calendar = Self.gregorianCalendar
        let now = Self.date(year: 2026, month: 2, day: 19)
        let completions = [
            Self.date(year: 2026, month: 2, day: 18),
            Self.date(year: 2026, month: 2, day: 11),
        ]
        let habit = Habit(
            name: "Strength",
            createdAt: Self.date(year: 2026, month: 2, day: 2),
            schedule: .weekly,
            completions: completions
        )
        let service = HabitStreakService(calendar: calendar, now: now)

        let snapshot = service.snapshot(for: habit)

        XCTAssertEqual(snapshot.currentStreak, 2)
        XCTAssertEqual(snapshot.perfectDays, 2)
    }

    func testSpecificDaysStreakIgnoresNonScheduledDays() {
        let calendar = Self.gregorianCalendar
        let now = Self.date(year: 2026, month: 2, day: 19)
        let completions = [
            Self.date(year: 2026, month: 2, day: 16),
            Self.date(year: 2026, month: 2, day: 18),
        ]
        let habit = Habit(
            name: "Workout",
            createdAt: Self.date(year: 2026, month: 2, day: 1),
            schedule: .specificDays([.monday, .wednesday, .friday]),
            completions: completions
        )
        let service = HabitStreakService(calendar: calendar, now: now)

        let snapshot = service.snapshot(for: habit)

        XCTAssertEqual(snapshot.currentStreak, 2)
        XCTAssertEqual(snapshot.perfectDays, 2)
    }

    func testFireVisualActivatesForDailyStreakAtFiveDays() {
        let calendar = Self.gregorianCalendar
        let now = Self.date(year: 2026, month: 2, day: 19)
        let completions = [
            Self.date(year: 2026, month: 2, day: 15),
            Self.date(year: 2026, month: 2, day: 16),
            Self.date(year: 2026, month: 2, day: 17),
            Self.date(year: 2026, month: 2, day: 18),
            Self.date(year: 2026, month: 2, day: 19),
        ]
        let habit = Habit(
            name: "Deep Work",
            createdAt: Self.date(year: 2026, month: 2, day: 1),
            schedule: .daily,
            completions: completions
        )
        let service = HabitStreakService(calendar: calendar, now: now)

        let snapshot = service.snapshot(for: habit)

        XCTAssertTrue(snapshot.fireVisualActive)
    }

    func testFireVisualActivatesForSpecificDaysAfterThreePerfectWeeks() {
        let calendar = Self.gregorianCalendar
        let now = Self.date(year: 2026, month: 2, day: 20)
        let completions = [
            Self.date(year: 2026, month: 2, day: 2),
            Self.date(year: 2026, month: 2, day: 4),
            Self.date(year: 2026, month: 2, day: 6),
            Self.date(year: 2026, month: 2, day: 9),
            Self.date(year: 2026, month: 2, day: 11),
            Self.date(year: 2026, month: 2, day: 13),
            Self.date(year: 2026, month: 2, day: 16),
            Self.date(year: 2026, month: 2, day: 18),
            Self.date(year: 2026, month: 2, day: 20),
        ]
        let habit = Habit(
            name: "Strength",
            createdAt: Self.date(year: 2026, month: 2, day: 1),
            schedule: .specificDays([.monday, .wednesday, .friday]),
            completions: completions
        )
        let service = HabitStreakService(calendar: calendar, now: now)

        let snapshot = service.snapshot(for: habit)

        XCTAssertTrue(snapshot.fireVisualActive)
    }

    func testFireVisualStaysInactiveWhenWeeklyStreakBelowThreshold() {
        let calendar = Self.gregorianCalendar
        let now = Self.date(year: 2026, month: 2, day: 19)
        let completions = [
            Self.date(year: 2026, month: 2, day: 18),
            Self.date(year: 2026, month: 2, day: 11),
        ]
        let habit = Habit(
            name: "Review",
            createdAt: Self.date(year: 2026, month: 2, day: 1),
            schedule: .weekly,
            completions: completions
        )
        let service = HabitStreakService(calendar: calendar, now: now)

        let snapshot = service.snapshot(for: habit)

        XCTAssertFalse(snapshot.fireVisualActive)
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
