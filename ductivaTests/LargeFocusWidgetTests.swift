import SwiftUI
import XCTest
@testable import ductiva

final class LargeFocusWidgetTests: XCTestCase {

    // MARK: - View Creation

    func testLargeFocusWidgetCanBeCreated() {
        let habit = makeHabit()
        let view = LargeFocusWidgetView(habit: habit, dayStates: [], monthTitle: "FEBRUARY 2026", currentDate: Self.fixedDate)
        XCTAssertNotNil(view)
    }

    func testLargeFocusWidgetCanBeCreatedWithNilHabit() {
        let view = LargeFocusWidgetView(habit: nil, dayStates: nil, monthTitle: nil, currentDate: Self.fixedDate)
        XCTAssertNotNil(view)
    }
    
    // MARK: - Data Mapping
    
    func testLargeFocusWidgetExposesHabitName() {
        let habit = makeHabit(name: "Deep Work")
        let view = LargeFocusWidgetView(habit: habit, dayStates: nil, monthTitle: nil, currentDate: Self.fixedDate)
        XCTAssertEqual(view.habit?.name, "Deep Work")
    }

    // MARK: - Body Rendering

    func testLargeFocusWidgetBodyRenders() {
        let habit = makeHabit()
        let view = LargeFocusWidgetView(habit: habit, dayStates: [], monthTitle: "FEB", currentDate: Self.fixedDate)
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

    private func makeHabit(
        name: String = "Deep Work",
        iconName: String = "display",
        schedule: HabitSchedule = .daily,
        completions: [Date] = [],
        currentStreak: Int = 0
    ) -> WidgetHabitSnapshot {
        WidgetHabitSnapshot(
            id: UUID(),
            name: name,
            iconName: iconName,
            schedule: schedule,
            completions: completions,
            currentStreak: currentStreak
        )
    }
}
