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

    // MARK: - Deep Linking Tests
    
    func testValidDeepLink() {
        let id = UUID()
        let url = URL(string: "ductiva://habit/\(id.uuidString)")!
        let route = HabitAppRoute(url: url)
        XCTAssertEqual(route, .habitDetail(id: id))
    }
    
    func testInvalidScheme() {
        let url = URL(string: "https://habit/123")!
        XCTAssertNil(HabitAppRoute(url: url))
    }
    
    func testInvalidHost() {
        let url = URL(string: "ductiva://settings/123")!
        XCTAssertNil(HabitAppRoute(url: url))
    }
    
    func testInvalidUUID() {
        let url = URL(string: "ductiva://habit/invalid-uuid")!
        XCTAssertNil(HabitAppRoute(url: url))
    }
}

