import Foundation
import XCTest
@testable import ductiva

final class HabitModelTests: XCTestCase {
    func testHabitInitializesWithExpectedProperties() {
        let createdAt = Date(timeIntervalSince1970: 1_700_000_000)

        let habit = Habit(name: "Read", createdAt: createdAt, schedule: .daily)

        XCTAssertEqual(habit.name, "Read")
        XCTAssertEqual(habit.createdAt, createdAt)
        XCTAssertEqual(habit.schedule, .daily)
        XCTAssertTrue(habit.completions.isEmpty)
    }

    func testHabitInitializesWithDefaultIcon() {
        let habit = Habit(name: "Meditate")

        XCTAssertEqual(habit.iconName, "target")
    }

    func testHabitInitializesWithCustomIcon() {
        let habit = Habit(name: "Workout", iconName: "dumbbell")

        XCTAssertEqual(habit.iconName, "dumbbell")
    }
}
