import Foundation
import XCTest
@testable import ductiva

final class WidgetSharedComponentsTests: XCTestCase {
    func testWidgetDeepLinkBuildsHabitURL() {
        let id = UUID(uuidString: "123E4567-E89B-12D3-A456-426614174000")!
        let url = WidgetDeepLink.habitURL(for: id)

        XCTAssertNotNil(url)
        XCTAssertEqual(url?.scheme, "ductiva")
        XCTAssertEqual(url?.host, "habit")
        XCTAssertEqual(url?.lastPathComponent, id.uuidString)
    }

    func testSnapshotCompletionUsesCalendarDayGranularity() {
        let calendar = Self.gregorianCalendar
        let date = Self.date(year: 2026, month: 2, day: 19, hour: 20)
        let habit = WidgetHabitSnapshot(
            id: UUID(),
            name: "Read",
            iconName: "book",
            schedule: .daily,
            completions: [Self.date(year: 2026, month: 2, day: 19, hour: 7)],
            currentStreak: 1
        )

        XCTAssertTrue(habit.isCompleted(on: date, calendar: calendar))
    }

    func testStatusTextReturnsDoneWhenCompleted() {
        let calendar = Self.gregorianCalendar
        let date = Self.date(year: 2026, month: 2, day: 19, hour: 10)
        let habit = WidgetHabitSnapshot(
            id: UUID(),
            name: "Read",
            iconName: "book",
            schedule: .daily,
            completions: [Self.date(year: 2026, month: 2, day: 19, hour: 7)],
            currentStreak: 1
        )

        XCTAssertEqual(habit.statusText(on: date, calendar: calendar), "Done")
    }

    func testStatusTextReturnsOffTodayWhenNotScheduled() {
        let calendar = Self.gregorianCalendar
        let tuesday = Self.date(year: 2026, month: 2, day: 17, hour: 10)
        let habit = WidgetHabitSnapshot(
            id: UUID(),
            name: "Workout",
            iconName: "dumbbell",
            schedule: .specificDays([.monday, .wednesday, .friday]),
            completions: [],
            currentStreak: 0
        )

        XCTAssertEqual(habit.statusText(on: tuesday, calendar: calendar), "Off Today")
    }

    func testStatusTextReturnsTimeLeftWhenScheduledAndIncomplete() {
        let calendar = Self.gregorianCalendar
        let date = Self.date(year: 2026, month: 2, day: 19, hour: 23, minute: 58)
        let habit = WidgetHabitSnapshot(
            id: UUID(),
            name: "Read",
            iconName: "book",
            schedule: .daily,
            completions: [],
            currentStreak: 0
        )

        XCTAssertEqual(habit.statusText(on: date, calendar: calendar), "1m")
    }

    private static let gregorianCalendar: Calendar = {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(identifier: "UTC")!
        return cal
    }()

    private static func date(year: Int, month: Int, day: Int, hour: Int, minute: Int = 0) -> Date {
        gregorianCalendar.date(
            from: DateComponents(year: year, month: month, day: day, hour: hour, minute: minute)
        )!
    }
}
