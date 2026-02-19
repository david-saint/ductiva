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

    private static let fixedDate: Date = {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(identifier: "UTC")!
        return cal.date(from: DateComponents(year: 2026, month: 2, day: 19, hour: 12))!
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
