import Foundation
import SwiftData
import XCTest
@testable import ductiva

final class ConfigurationViewModelTests: XCTestCase {
    private func makeViewModel() throws -> (ConfigurationViewModel, HabitStore) {
        let container = try ductivaApp.makeModelContainer(inMemoryOnly: true)
        let context = ModelContext(container)
        let store = HabitStore(modelContext: context)
        let viewModel = ConfigurationViewModel(habitStore: store)
        return (viewModel, store)
    }

    func testMaxSlotsIsFour() {
        XCTAssertEqual(ConfigurationViewModel.maxSlots, 4)
    }

    func testSlotCounterText() throws {
        let (viewModel, _) = try makeViewModel()
        XCTAssertEqual(viewModel.slotCounterText, "0/4 SLOTS ACTIVE")
    }

    func testCanAddSlotTrueUnderMax() throws {
        let (viewModel, _) = try makeViewModel()
        XCTAssertTrue(viewModel.canAddSlot)
    }

    func testCanAddSlotFalseAtMax() throws {
        let (viewModel, store) = try makeViewModel()
        for i in 1...4 {
            _ = try store.createHabit(name: "Habit \(i)", schedule: .daily)
        }
        viewModel.loadHabits()

        XCTAssertFalse(viewModel.canAddSlot)
    }

    func testLoadHabitsFromStore() throws {
        let (viewModel, store) = try makeViewModel()
        _ = try store.createHabit(name: "Read", schedule: .daily)
        _ = try store.createHabit(name: "Code", schedule: .weekly)

        viewModel.loadHabits()

        XCTAssertEqual(viewModel.habits.count, 2)
    }

    func testLaunchAtLoginDefaultsFalse() throws {
        let (viewModel, _) = try makeViewModel()
        XCTAssertFalse(viewModel.launchAtLogin)
    }

    func testShowInMenuBarDefaultsTrue() throws {
        let (viewModel, _) = try makeViewModel()
        XCTAssertTrue(viewModel.showInMenuBar)
    }

    func testSlotCounterTextUpdatesAfterLoad() throws {
        let (viewModel, store) = try makeViewModel()
        _ = try store.createHabit(name: "Read", schedule: .daily)
        _ = try store.createHabit(name: "Code", schedule: .weekly)
        viewModel.loadHabits()

        XCTAssertEqual(viewModel.slotCounterText, "2/4 SLOTS ACTIVE")
    }

    // MARK: - Task 2.1 Tests

    func testLoadHabitsPopulatesArray() throws {
        let (viewModel, store) = try makeViewModel()
        _ = try store.createHabit(name: "Deep Work", iconName: "display", schedule: .daily)
        _ = try store.createHabit(name: "Strength Training", iconName: "dumbbell", schedule: .daily)
        _ = try store.createHabit(name: "Side Project", iconName: "chevron.left.forwardslash.chevron.right", schedule: .weekly)

        viewModel.loadHabits()

        XCTAssertEqual(viewModel.habits.count, 3)
        let names = viewModel.habits.map(\.name)
        XCTAssertTrue(names.contains("Deep Work"))
        XCTAssertTrue(names.contains("Strength Training"))
        XCTAssertTrue(names.contains("Side Project"))
    }

    func testEmptyStoreReturnsEmpty() throws {
        let (viewModel, _) = try makeViewModel()
        viewModel.loadHabits()

        XCTAssertTrue(viewModel.habits.isEmpty)
        XCTAssertEqual(viewModel.activeSlotCount, 0)
    }
}
