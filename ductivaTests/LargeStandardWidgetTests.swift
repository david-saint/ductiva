import SwiftUI
import XCTest
@testable import ductiva

final class LargeStandardWidgetTests: XCTestCase {

    func testLargeStandardWidgetCanBeCreated() {
        let view = LargeStandardWidgetView(habits: [], currentDate: Self.fixedDate)
        XCTAssertNotNil(view)
    }

    func testLargeStandardWidgetCapsAtEightHabits() {
        let habits = makeHabits(count: 10)
        let view = LargeStandardWidgetView(habits: habits, currentDate: Self.fixedDate)
        XCTAssertEqual(view.displayedHabits.count, 8)
    }

    func testLargeStandardWidgetDetectsCompletedHabit() {
        let calendar = Self.gregorianCalendar
        let todayStart = calendar.startOfDay(for: Self.fixedDate)
        let habit = WidgetHabitSnapshot(
            id: UUID(),
            name: "Done",
            iconName: "checkmark.circle",
            schedule: .daily,
            completions: [todayStart],
            currentStreak: 3
        )
        let view = LargeStandardWidgetView(habits: [habit], currentDate: Self.fixedDate)

        XCTAssertTrue(view.isCompleted(habit))
    }

    func testLargeStandardWidgetDetectsIncompleteHabit() {
        let habit = WidgetHabitSnapshot(
            id: UUID(),
            name: "Pending",
            iconName: "circle",
            schedule: .daily,
            completions: [],
            currentStreak: 0
        )
        let view = LargeStandardWidgetView(habits: [habit], currentDate: Self.fixedDate)

        XCTAssertFalse(view.isCompleted(habit))
    }

    func testLargeStandardWidgetBodyRendersWithHabits() {
        let habits = makeHabits(count: 3)
        let view = LargeStandardWidgetView(habits: habits, currentDate: Self.fixedDate)
        XCTAssertNotNil(view.body)
    }

    func testLargeStandardWidgetBodyRendersEmptyState() {
        let view = LargeStandardWidgetView(habits: [], currentDate: Self.fixedDate)
        XCTAssertNotNil(view.body)
    }

    private static let gregorianCalendar: Calendar = {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(identifier: "UTC")!
        return cal
    }()

    private static let fixedDate: Date = {
        gregorianCalendar.date(from: DateComponents(year: 2026, month: 2, day: 19, hour: 12))!
    }()

    private func makeHabits(count: Int) -> [WidgetHabitSnapshot] {
        return (0..<count).map { i in
            WidgetHabitSnapshot(
                id: UUID(),
                name: "Test \(i)",
                iconName: "circle",
                schedule: .daily,
                completions: [],
                currentStreak: i
            )
        }
    }
}
