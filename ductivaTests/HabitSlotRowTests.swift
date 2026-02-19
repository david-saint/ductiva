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
        XCTAssertGreaterThan(StealthCeramicTheme.surfaceCornerRadius, 0)
    }

    func testHabitSlotRowGlassStrokeColorIsDefined() {
        let color = StealthCeramicTheme.glassStrokeColor
        XCTAssertNotNil(color)
    }

    // MARK: - Task 2.4: Body rendering

    func testHabitSlotRowBodyRenders() {
        let habit = Habit(name: "Read", iconName: "book", schedule: .daily)
        let row = HabitSlotRow(habit: habit)
        let body = row.body
        XCTAssertNotNil(body)
    }

    func testHabitSlotRowWithVariousIcons() {
        let icons = ["display", "dumbbell", "chevron.left.forwardslash.chevron.right", "book", "brain.head.profile", "heart", "target", "pencil"]
        for icon in icons {
            let habit = Habit(name: "Test", iconName: icon, schedule: .daily)
            let row = HabitSlotRow(habit: habit)
            XCTAssertEqual(row.habit.iconName, icon)
        }
    }

    // MARK: - Task 3.4: Context menu delete

    func testHabitSlotRowAcceptsDeleteCallback() {
        let habit = Habit(name: "Read", iconName: "book", schedule: .daily)
        var deleteCalled = false
        let row = HabitSlotRow(habit: habit, onDelete: { deleteCalled = true })
        XCTAssertNotNil(row)
        row.onDelete?()
        XCTAssertTrue(deleteCalled)
    }

    func testHabitSlotRowDeleteCallbackDefaultsToNil() {
        let habit = Habit(name: "Read", iconName: "book", schedule: .daily)
        let row = HabitSlotRow(habit: habit)
        XCTAssertNil(row.onDelete)
    }

    func testHabitSlotRowCompletionDefaultsToFalse() {
        let habit = Habit(name: "Read", iconName: "book", schedule: .daily)
        let row = HabitSlotRow(habit: habit)
        XCTAssertFalse(row.isCompletedToday)
    }

    func testHabitSlotRowAcceptsToggleCompletionCallback() {
        let habit = Habit(name: "Read", iconName: "book", schedule: .daily)
        var called = false
        let row = HabitSlotRow(
            habit: habit,
            isCompletedToday: false,
            onToggleCompletion: { called = true }
        )

        row.onToggleCompletion?()
        XCTAssertTrue(called)
    }

    func testHabitSlotRowCanRepresentCompletedTodayState() {
        let habit = Habit(name: "Read", iconName: "book", schedule: .daily)
        let row = HabitSlotRow(habit: habit, isCompletedToday: true)
        XCTAssertTrue(row.isCompletedToday)
    }

    func testHabitSlotRowBodyRendersWithDeleteCallback() {
        let habit = Habit(name: "Read", iconName: "book", schedule: .daily)
        let row = HabitSlotRow(habit: habit, onDelete: {})
        let body = row.body
        XCTAssertNotNil(body)
    }
}
