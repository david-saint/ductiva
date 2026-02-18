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
}
