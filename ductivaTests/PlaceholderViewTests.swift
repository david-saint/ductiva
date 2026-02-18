import SwiftUI
import XCTest
@testable import ductiva

final class PlaceholderViewTests: XCTestCase {
    func testWidgetsPlaceholderViewBodyRenders() {
        let view = WidgetsPlaceholderView()
        _ = view.body
    }

    func testHabitStreakPlaceholderViewBodyRenders() {
        let habit = Habit(name: "Read", iconName: "book")
        let view = HabitStreakPlaceholderView(habit: habit)
        XCTAssertEqual(view.habit.name, "Read")
        _ = view.body
    }
}
