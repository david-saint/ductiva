import XCTest
@testable import ductiva

final class PlaceholderViewTests: XCTestCase {
    func testWidgetsPlaceholderViewCanBeCreated() {
        _ = WidgetsPlaceholderView()
    }

    func testHabitStreakPlaceholderViewCanBeCreated() {
        let habit = Habit(name: "Read", iconName: "book")
        _ = HabitStreakPlaceholderView(habit: habit)
    }
}
