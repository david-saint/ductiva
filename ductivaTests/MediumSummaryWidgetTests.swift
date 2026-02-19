import SwiftUI
import XCTest
@testable import ductiva

final class MediumSummaryWidgetTests: XCTestCase {

    // MARK: - View Creation

    func testMediumSummaryWidgetCanBeCreated() {
        let habits = makeHabits(count: 4)
        let view = MediumSummaryWidgetView(habits: habits, currentDate: Self.fixedDate)
        XCTAssertNotNil(view)
    }

    func testMediumSummaryWidgetAcceptsEmptyHabits() {
        let view = MediumSummaryWidgetView(habits: [], currentDate: Self.fixedDate)
        XCTAssertNotNil(view)
    }

    // MARK: - Data Mapping

    func testMediumSummaryWidgetCapsAtFourHabits() {
        let habits = makeHabits(count: 6)
        let view = MediumSummaryWidgetView(habits: habits, currentDate: Self.fixedDate)
        XCTAssertEqual(view.displayedHabits.count, 4)
    }

    func testMediumSummaryWidgetDisplaysFewerThanFour() {
        let habits = makeHabits(count: 2)
        let view = MediumSummaryWidgetView(habits: habits, currentDate: Self.fixedDate)
        XCTAssertEqual(view.displayedHabits.count, 2)
    }

    // MARK: - Completion State

    func testMediumSummaryWidgetDetectsCompletedHabit() {
        let calendar = Self.gregorianCalendar
        let today = Self.fixedDate
        let habit = WidgetHabitSnapshot(
            id: UUID(),
            name: "Test",
            iconName: "target",
            schedule: .daily,
            completions: [calendar.startOfDay(for: today)],
            currentStreak: 1
        )
        let view = MediumSummaryWidgetView(habits: [habit], currentDate: today)
        XCTAssertTrue(view.isCompleted(habit))
    }

    func testMediumSummaryWidgetDetectsIncompleteHabit() {
        let habit = WidgetHabitSnapshot(
            id: UUID(),
            name: "Test",
            iconName: "target",
            schedule: .daily,
            completions: [],
            currentStreak: 0
        )
        let view = MediumSummaryWidgetView(habits: [habit], currentDate: Self.fixedDate)
        XCTAssertFalse(view.isCompleted(habit))
    }

    // MARK: - Body Rendering

    func testMediumSummaryWidgetBodyRenders() {
        let habits = makeHabits(count: 4)
        let view = MediumSummaryWidgetView(habits: habits, currentDate: Self.fixedDate)
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
        let icons = ["display", "dumbbell", "book", "brain.head.profile"]
        let names = ["Deep Work", "Exercise", "Reading", "Meditate"]
        return (0..<count).map { i in
            WidgetHabitSnapshot(
                id: UUID(),
                name: names[i % names.count],
                iconName: icons[i % icons.count],
                schedule: .daily,
                completions: [],
                currentStreak: i * 2
            )
        }
    }
}
