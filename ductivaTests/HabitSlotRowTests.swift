import SwiftUI
import SwiftData
import XCTest
@testable import ductiva

final class HabitSlotRowTests: XCTestCase {
    func testHabitSlotRowCanBeCreated() {
        let habit = Habit(name: "Deep Work", iconName: "display", schedule: .daily)
        let row = HabitSlotRow(habit: habit)
        XCTAssertNotNil(row)
    }

    func testHabitSlotRowDisplaysHabitName() {
        let habit = Habit(name: "Strength Training", iconName: "dumbbell", schedule: .daily)
        let row = HabitSlotRow(habit: habit)
        XCTAssertEqual(row.habit.name, "Strength Training")
    }

    func testHabitSlotRowDisplaysHabitIcon() {
        let habit = Habit(name: "Side Project", iconName: "chevron.left.forwardslash.chevron.right", schedule: .daily)
        let row = HabitSlotRow(habit: habit)
        XCTAssertEqual(row.habit.iconName, "chevron.left.forwardslash.chevron.right")
    }
}
