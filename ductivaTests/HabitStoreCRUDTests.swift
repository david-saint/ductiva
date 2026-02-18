import Foundation
import SwiftData
import XCTest
@testable import ductiva

final class HabitStoreCRUDTests: XCTestCase {
    private var container: ModelContainer!
    private var context: ModelContext!
    private var store: HabitStore!

    override func setUpWithError() throws {
        container = try ductivaApp.makeModelContainer(inMemoryOnly: true)
        context = ModelContext(container)
        store = HabitStore(modelContext: context)
    }

    override func tearDownWithError() throws {
        store = nil
        context = nil
        container = nil
    }

    func testCreateAndFetchHabits() throws {
        _ = try store.createHabit(name: "Workout", schedule: .daily)

        let habits = try store.fetchHabits()

        XCTAssertEqual(habits.count, 1)
        XCTAssertEqual(habits.first?.name, "Workout")
        XCTAssertEqual(habits.first?.schedule, .daily)
    }

    func testUpdateHabitPersistsChanges() throws {
        let habit = try store.createHabit(name: "Read", schedule: .daily)

        try store.updateHabit(habit, name: "Deep Read", schedule: .weekly)

        let habits = try store.fetchHabits()
        XCTAssertEqual(habits.first?.name, "Deep Read")
        XCTAssertEqual(habits.first?.schedule, .weekly)
    }

    func testDeleteHabitRemovesRecord() throws {
        let habit = try store.createHabit(name: "Stretch", schedule: .daily)

        try store.deleteHabit(habit)

        let habits = try store.fetchHabits()
        XCTAssertTrue(habits.isEmpty)
    }
}
