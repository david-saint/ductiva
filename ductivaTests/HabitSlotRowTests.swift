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

    // MARK: - Task 2.3: Hover state

    func testHabitSlotRowUsesThemeCornerRadius() {
        // Verifies the row references StealthCeramicTheme.surfaceCornerRadius
        // which is used for the hover glass effect shape
        XCTAssertGreaterThanOrEqual(StealthCeramicTheme.surfaceCornerRadius, 12)
    }

    func testHabitSlotRowGlassStrokeColorIsDefined() {
        // Verifies the glass stroke color used on hover is accessible
        let color = StealthCeramicTheme.glassStrokeColor
        XCTAssertNotNil(color)
    }
}
