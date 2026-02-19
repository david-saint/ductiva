import SwiftData
import XCTest
@testable import ductiva

final class NavigationTests: XCTestCase {
    func testHabitStreakPlaceholderDisplaysHabitInfo() {
        let habit = Habit(name: "Workout", iconName: "dumbbell")
        let view = HabitStreakPlaceholderView(habit: habit)
        XCTAssertEqual(view.habit.name, "Workout")
        XCTAssertEqual(view.habit.iconName, "dumbbell")
    }

    func testWidgetsPlaceholderViewExists() {
        _ = WidgetsPlaceholderView()
    }

    func testConfigurationViewAcceptsViewModel() throws {
        let container = try SharedContainer.makeInMemory()
        let context = ModelContext(container)
        let store = HabitStore(modelContext: context)
        let viewModel = ConfigurationViewModel(habitStore: store)
        let view = ConfigurationView(viewModel: viewModel)
        XCTAssertNotNil(view)
    }
}
