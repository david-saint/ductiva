import Foundation
import SwiftData
import XCTest
@testable import ductiva

final class HabitStoreCRUDTests: XCTestCase {
    private var container: ModelContainer!
    private var context: ModelContext!
    private var store: HabitStore!

    override func setUpWithError() throws {
        container = try SharedContainer.makeInMemory()
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

    func testToggleCompletionAddsAndRemovesDayEntry() throws {
        let calendar = Self.gregorianCalendar
        let day = Self.date(year: 2026, month: 2, day: 19)
        let habit = try store.createHabit(name: "Read", schedule: .daily)

        let markedComplete = try store.toggleCompletion(habit, on: day, calendar: calendar)
        XCTAssertTrue(markedComplete)
        XCTAssertTrue(store.isCompleted(habit, on: day, calendar: calendar))

        let markedIncomplete = try store.toggleCompletion(habit, on: day, calendar: calendar)
        XCTAssertFalse(markedIncomplete)
        XCTAssertFalse(store.isCompleted(habit, on: day, calendar: calendar))
    }

    func testIsCompletedUsesCalendarDayGranularity() throws {
        let calendar = Self.gregorianCalendar
        let habit = try store.createHabit(name: "Meditate", schedule: .daily)
        let completion = Self.date(year: 2026, month: 2, day: 19, hour: 8)
        let sameDayLater = Self.date(year: 2026, month: 2, day: 19, hour: 20)

        _ = try store.toggleCompletion(habit, on: completion, calendar: calendar)
        XCTAssertTrue(store.isCompleted(habit, on: sameDayLater, calendar: calendar))
    }

    private static var gregorianCalendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }

    private static func date(year: Int, month: Int, day: Int, hour: Int = 12) -> Date {
        DateComponents(
            calendar: gregorianCalendar,
            timeZone: gregorianCalendar.timeZone,
            year: year,
            month: month,
            day: day,
            hour: hour
        ).date!
    }
}
