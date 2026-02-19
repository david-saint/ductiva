import SwiftUI
import XCTest
@testable import ductiva

final class SmallStandardWidgetTests: XCTestCase {

    // MARK: - View Creation

    func testSmallStandardWidgetCanBeCreated() {
        let habits = makeHabits(count: 4)
        let view = SmallStandardWidgetView(habits: habits, currentDate: Self.fixedDate)
        XCTAssertNotNil(view)
    }

    func testSmallStandardWidgetAcceptsEmptyHabits() {
        let view = SmallStandardWidgetView(habits: [], currentDate: Self.fixedDate)
        XCTAssertNotNil(view)
    }

    // MARK: - Data Mapping

    func testSmallStandardWidgetExposesFourHabits() {
        let habits = makeHabits(count: 4)
        let view = SmallStandardWidgetView(habits: habits, currentDate: Self.fixedDate)
        XCTAssertEqual(view.habits.count, 4)
    }

    func testSmallStandardWidgetCapsAtFourHabits() {
        let habits = makeHabits(count: 6)
        let view = SmallStandardWidgetView(habits: habits, currentDate: Self.fixedDate)
        // The view should only display up to 4 habits
        XCTAssertEqual(view.displayedHabits.count, 4)
    }

    func testSmallStandardWidgetDisplaysFewerThanFour() {
        let habits = makeHabits(count: 2)
        let view = SmallStandardWidgetView(habits: habits, currentDate: Self.fixedDate)
        XCTAssertEqual(view.displayedHabits.count, 2)
    }

    // MARK: - Grid Layout

    func testSmallStandardWidgetGridRows() {
        let habits = makeHabits(count: 4)
        let view = SmallStandardWidgetView(habits: habits, currentDate: Self.fixedDate)
        // 2x2 grid: 2 rows
        XCTAssertEqual(view.gridRows, 2)
    }

    func testSmallStandardWidgetGridRowsWithTwoHabits() {
        let habits = makeHabits(count: 2)
        let view = SmallStandardWidgetView(habits: habits, currentDate: Self.fixedDate)
        // 2 habits = 1 row of 2
        XCTAssertEqual(view.gridRows, 1)
    }

    func testSmallStandardWidgetGridRowsWithThreeHabits() {
        let habits = makeHabits(count: 3)
        let view = SmallStandardWidgetView(habits: habits, currentDate: Self.fixedDate)
        // 3 habits = 2 rows (2 + 1)
        XCTAssertEqual(view.gridRows, 2)
    }

    func testSmallStandardWidgetGridRowsWithOneHabit() {
        let habits = makeHabits(count: 1)
        let view = SmallStandardWidgetView(habits: habits, currentDate: Self.fixedDate)
        XCTAssertEqual(view.gridRows, 1)
    }

    // MARK: - Completion State

    func testSmallStandardWidgetDetectsCompletedHabit() {
        let calendar = Self.gregorianCalendar
        let today = Self.fixedDate
        let habit = WidgetHabitSnapshot(
            id: UUID(),
            name: "Test",
            iconName: "target",
            schedule: .daily,
            completions: [calendar.startOfDay(for: today)]
        )
        let view = SmallStandardWidgetView(habits: [habit], currentDate: today)
        XCTAssertTrue(view.isCompleted(habit))
    }

    func testSmallStandardWidgetDetectsIncompleteHabit() {
        let habit = WidgetHabitSnapshot(
            id: UUID(),
            name: "Test",
            iconName: "target",
            schedule: .daily,
            completions: []
        )
        let view = SmallStandardWidgetView(habits: [habit], currentDate: Self.fixedDate)
        XCTAssertFalse(view.isCompleted(habit))
    }

    // MARK: - Body Rendering

    func testSmallStandardWidgetBodyRenders() {
        let habits = makeHabits(count: 4)
        let view = SmallStandardWidgetView(habits: habits, currentDate: Self.fixedDate)
        let body = view.body
        XCTAssertNotNil(body)
    }

    func testSmallStandardWidgetBodyRendersEmpty() {
        let view = SmallStandardWidgetView(habits: [], currentDate: Self.fixedDate)
        let body = view.body
        XCTAssertNotNil(body)
    }

    // MARK: - Helpers

    private static let gregorianCalendar: Calendar = {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(identifier: "UTC")!
        return cal
    }()

    private static let fixedDate: Date = {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(identifier: "UTC")!
        return cal.date(from: DateComponents(year: 2026, month: 2, day: 19, hour: 12))!
    }()

    private func makeHabits(count: Int) -> [WidgetHabitSnapshot] {
        let icons = ["display", "dumbbell", "book", "brain.head.profile", "heart", "target"]
        let names = ["Deep Work", "Exercise", "Reading", "Meditate", "Cardio", "Focus"]
        return (0..<count).map { i in
            WidgetHabitSnapshot(
                id: UUID(),
                name: names[i % names.count],
                iconName: icons[i % icons.count],
                schedule: .daily,
                completions: []
            )
        }
    }
}
