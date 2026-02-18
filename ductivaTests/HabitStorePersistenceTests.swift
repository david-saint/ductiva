import Foundation
import SwiftData
import XCTest
@testable import ductiva

final class HabitStorePersistenceTests: XCTestCase {
    private var container: ModelContainer!

    override func setUpWithError() throws {
        container = try ductivaApp.makeModelContainer(inMemoryOnly: true)
    }

    override func tearDownWithError() throws {
        container = nil
    }

    func testFetchHabitsReturnsNewestFirst() throws {
        let context = ModelContext(container)
        let store = HabitStore(modelContext: context)

        _ = try store.createHabit(
            name: "Older Habit",
            schedule: .daily,
            createdAt: Date(timeIntervalSince1970: 1_700_000_000)
        )
        _ = try store.createHabit(
            name: "Newer Habit",
            schedule: .daily,
            createdAt: Date(timeIntervalSince1970: 1_800_000_000)
        )

        let habits = try store.fetchHabits()

        XCTAssertEqual(habits.map(\.name), ["Newer Habit", "Older Habit"])
    }

    func testHabitPersistsAcrossContextsWithScheduleAndCompletions() throws {
        let writeContext = ModelContext(container)
        let writeStore = HabitStore(modelContext: writeContext)
        let completionDate = Date(timeIntervalSince1970: 1_800_000_100)

        _ = try writeStore.createHabit(
            name: "Hydrate",
            schedule: .specificDays([.monday, .wednesday, .friday]),
            createdAt: Date(timeIntervalSince1970: 1_800_000_000),
            completions: [completionDate]
        )

        let readContext = ModelContext(container)
        let readStore = HabitStore(modelContext: readContext)
        let habits = try readStore.fetchHabits()

        XCTAssertEqual(habits.count, 1)
        XCTAssertEqual(habits[0].name, "Hydrate")
        XCTAssertEqual(habits[0].schedule, .specificDays([.monday, .wednesday, .friday]))
        XCTAssertEqual(habits[0].completions, [completionDate])
    }
}
