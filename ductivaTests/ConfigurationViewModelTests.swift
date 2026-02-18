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
}
