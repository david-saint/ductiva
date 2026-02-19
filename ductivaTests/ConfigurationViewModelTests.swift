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

    // MARK: - Task 2.4: List rendering & edge cases

    func testSlotCounterTextAtMaxSlots() throws {
        let (viewModel, store) = try makeViewModel()
        for i in 1...4 {
            _ = try store.createHabit(name: "Habit \(i)", schedule: .daily)
        }
        viewModel.loadHabits()

        XCTAssertEqual(viewModel.slotCounterText, "4/4 SLOTS ACTIVE")
    }

    func testActiveSlotCountMatchesHabitCount() throws {
        let (viewModel, store) = try makeViewModel()
        _ = try store.createHabit(name: "Read", schedule: .daily)
        viewModel.loadHabits()

        XCTAssertEqual(viewModel.activeSlotCount, 1)
        XCTAssertEqual(viewModel.habits.count, viewModel.activeSlotCount)
    }

    func testCanAddSlotWithThreeHabits() throws {
        let (viewModel, store) = try makeViewModel()
        for i in 1...3 {
            _ = try store.createHabit(name: "Habit \(i)", schedule: .daily)
        }
        viewModel.loadHabits()

        XCTAssertTrue(viewModel.canAddSlot)
        XCTAssertEqual(viewModel.activeSlotCount, 3)
    }

    func testLoadHabitsPreservesIconNames() throws {
        let (viewModel, store) = try makeViewModel()
        _ = try store.createHabit(name: "Deep Work", iconName: "display", schedule: .daily)
        _ = try store.createHabit(name: "Strength Training", iconName: "dumbbell", schedule: .weekly)
        viewModel.loadHabits()

        let icons = viewModel.habits.map(\.iconName)
        XCTAssertTrue(icons.contains("display"))
        XCTAssertTrue(icons.contains("dumbbell"))
    }

    func testScheduleDescriptionForDaily() {
        let description = ConfigurationViewModel.scheduleDescription(for: .daily)
        XCTAssertEqual(description, "Daily")
    }

    func testScheduleDescriptionForWeekly() {
        let description = ConfigurationViewModel.scheduleDescription(for: .weekly)
        XCTAssertEqual(description, "Weekly")
    }

    func testScheduleDescriptionForEmptySpecificDays() {
        let description = ConfigurationViewModel.scheduleDescription(for: .specificDays([]))
        XCTAssertEqual(description, "Specific Days")
    }

    func testWeekdayAbbreviations() {
        XCTAssertEqual(ConfigurationViewModel.weekdayAbbreviation(for: .sunday), "Sun")
        XCTAssertEqual(ConfigurationViewModel.weekdayAbbreviation(for: .monday), "Mon")
        XCTAssertEqual(ConfigurationViewModel.weekdayAbbreviation(for: .tuesday), "Tue")
        XCTAssertEqual(ConfigurationViewModel.weekdayAbbreviation(for: .wednesday), "Wed")
        XCTAssertEqual(ConfigurationViewModel.weekdayAbbreviation(for: .thursday), "Thu")
        XCTAssertEqual(ConfigurationViewModel.weekdayAbbreviation(for: .friday), "Fri")
        XCTAssertEqual(ConfigurationViewModel.weekdayAbbreviation(for: .saturday), "Sat")
    }

    // MARK: - Task 3.3: Add/Remove integration

    func testAddHabitPersists() throws {
        let (viewModel, _) = try makeViewModel()
        viewModel.loadHabits()
        XCTAssertTrue(viewModel.habits.isEmpty)

        viewModel.addHabit(name: "Deep Work", iconName: "display", schedule: .daily)
        XCTAssertEqual(viewModel.habits.count, 1)
        XCTAssertEqual(viewModel.habits.first?.name, "Deep Work")
        XCTAssertEqual(viewModel.habits.first?.iconName, "display")
        XCTAssertEqual(viewModel.habits.first?.schedule, .daily)
    }

    func testRemoveHabitDeletes() throws {
        let (viewModel, store) = try makeViewModel()
        _ = try store.createHabit(name: "Workout", iconName: "dumbbell", schedule: .daily)
        viewModel.loadHabits()
        XCTAssertEqual(viewModel.habits.count, 1)

        let habit = viewModel.habits[0]
        viewModel.removeHabit(habit)
        XCTAssertTrue(viewModel.habits.isEmpty)
    }

    func testAddBlockedAtMaxSlots() throws {
        let (viewModel, store) = try makeViewModel()
        for i in 1...4 {
            _ = try store.createHabit(name: "Habit \(i)", schedule: .daily)
        }
        viewModel.loadHabits()
        XCTAssertEqual(viewModel.habits.count, 4)
        XCTAssertFalse(viewModel.canAddSlot)

        viewModel.addHabit(name: "Blocked Habit", iconName: "target", schedule: .daily)
        XCTAssertEqual(viewModel.habits.count, 4, "Should not exceed max slots")
    }

    func testAddHabitUpdatesSlotCounter() throws {
        let (viewModel, _) = try makeViewModel()
        viewModel.addHabit(name: "Read", iconName: "book", schedule: .weekly)
        XCTAssertEqual(viewModel.slotCounterText, "1/4 SLOTS ACTIVE")
    }

    func testRemoveHabitUpdatesCanAddSlot() throws {
        let (viewModel, store) = try makeViewModel()
        for i in 1...4 {
            _ = try store.createHabit(name: "Habit \(i)", schedule: .daily)
        }
        viewModel.loadHabits()
        XCTAssertFalse(viewModel.canAddSlot)

        viewModel.removeHabit(viewModel.habits[0])
        XCTAssertTrue(viewModel.canAddSlot)
    }

    func testAddHabitWithSpecificDays() throws {
        let (viewModel, _) = try makeViewModel()
        viewModel.addHabit(name: "Yoga", iconName: "heart", schedule: .specificDays([.monday, .wednesday, .friday]))
        XCTAssertEqual(viewModel.habits.count, 1)
        XCTAssertEqual(viewModel.habits.first?.schedule, .specificDays([.monday, .wednesday, .friday]))
    }

    func testAddHabitWithWeeklySchedule() throws {
        let (viewModel, _) = try makeViewModel()
        viewModel.addHabit(name: "Review", iconName: "book", schedule: .weekly)
        XCTAssertEqual(viewModel.habits.first?.schedule, .weekly)
    }

    func testAddMultipleHabitsUpToMax() throws {
        let (viewModel, _) = try makeViewModel()
        viewModel.addHabit(name: "Habit 1", iconName: "target", schedule: .daily)
        viewModel.addHabit(name: "Habit 2", iconName: "book", schedule: .daily)
        viewModel.addHabit(name: "Habit 3", iconName: "heart", schedule: .weekly)
        viewModel.addHabit(name: "Habit 4", iconName: "dumbbell", schedule: .daily)
        XCTAssertEqual(viewModel.habits.count, 4)
        XCTAssertFalse(viewModel.canAddSlot)
    }

    // MARK: - Task 4.2: Save/Discard settings

    func testSaveChangesPersistsSettings() throws {
        let (viewModel, _) = try makeViewModel()
        let defaults = UserDefaults.standard

        // Change settings
        viewModel.launchAtLogin = true
        viewModel.showInMenuBar = false

        viewModel.saveChanges()

        XCTAssertTrue(defaults.bool(forKey: "launchAtLogin"))
        XCTAssertFalse(defaults.bool(forKey: "showInMenuBar"))

        // Clean up
        defaults.removeObject(forKey: "launchAtLogin")
        defaults.removeObject(forKey: "showInMenuBar")
    }

    func testDiscardChangesRevertsSettings() throws {
        let (viewModel, _) = try makeViewModel()
        let defaults = UserDefaults.standard

        // Save known state
        defaults.set(false, forKey: "launchAtLogin")
        defaults.set(true, forKey: "showInMenuBar")

        // Modify in-memory
        viewModel.launchAtLogin = true
        viewModel.showInMenuBar = false

        // Discard should revert to persisted values
        viewModel.discardChanges()

        XCTAssertFalse(viewModel.launchAtLogin)
        XCTAssertTrue(viewModel.showInMenuBar)

        // Clean up
        defaults.removeObject(forKey: "launchAtLogin")
        defaults.removeObject(forKey: "showInMenuBar")
    }

    func testDiscardChangesAlsoReloadsHabits() throws {
        let (viewModel, store) = try makeViewModel()
        _ = try store.createHabit(name: "Read", schedule: .daily)
        viewModel.loadHabits()
        XCTAssertEqual(viewModel.habits.count, 1)

        // Add another habit to the store directly
        _ = try store.createHabit(name: "Code", schedule: .weekly)

        // Discard should reload from store
        viewModel.discardChanges()
        XCTAssertEqual(viewModel.habits.count, 2)
    }

    // MARK: - Task 4.6: Coverage gap tests

    #if DEBUG
    func testSeedSampleHabitsIfEmptyPopulatesHabits() throws {
        let (viewModel, _) = try makeViewModel()
        viewModel.seedSampleHabitsIfEmpty()
        XCTAssertFalse(viewModel.habits.isEmpty, "Should seed at least one sample habit")
    }

    func testSeedSampleHabitsIfEmptyDoesNotDuplicateWhenHabitsExist() throws {
        let (viewModel, store) = try makeViewModel()
        _ = try store.createHabit(name: "Existing", schedule: .daily)
        viewModel.loadHabits()
        let countBefore = viewModel.habits.count

        viewModel.seedSampleHabitsIfEmpty()
        XCTAssertEqual(viewModel.habits.count, countBefore, "Should not seed when habits already exist")
    }
    #endif

    // MARK: - hasUnsavedChanges

    func testHasUnsavedChangesIsFalseInitially() throws {
        let (viewModel, _) = try makeViewModel()
        XCTAssertFalse(viewModel.hasUnsavedChanges)
    }

    func testHasUnsavedChangesIsTrueAfterTogglingLaunchAtLogin() throws {
        let (viewModel, _) = try makeViewModel()
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "launchAtLogin")

        viewModel.launchAtLogin = true
        XCTAssertTrue(viewModel.hasUnsavedChanges)

        defaults.removeObject(forKey: "launchAtLogin")
    }

    func testHasUnsavedChangesIsTrueAfterTogglingShowInMenuBar() throws {
        let (viewModel, _) = try makeViewModel()
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "showInMenuBar")

        viewModel.showInMenuBar = false
        XCTAssertTrue(viewModel.hasUnsavedChanges)

        defaults.removeObject(forKey: "showInMenuBar")
    }

    func testHasUnsavedChangesIsFalseAfterSave() throws {
        let (viewModel, _) = try makeViewModel()
        viewModel.launchAtLogin = true
        XCTAssertTrue(viewModel.hasUnsavedChanges)

        viewModel.saveChanges()
        XCTAssertFalse(viewModel.hasUnsavedChanges)

        UserDefaults.standard.removeObject(forKey: "launchAtLogin")
    }

    func testHasUnsavedChangesIsFalseAfterDiscard() throws {
        let (viewModel, _) = try makeViewModel()
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "launchAtLogin")
        defaults.set(true, forKey: "showInMenuBar")

        viewModel.launchAtLogin = true
        XCTAssertTrue(viewModel.hasUnsavedChanges)

        viewModel.discardChanges()
        XCTAssertFalse(viewModel.hasUnsavedChanges)

        defaults.removeObject(forKey: "launchAtLogin")
        defaults.removeObject(forKey: "showInMenuBar")
    }

    func testHasUnsavedChangesIsFalseWhenToggledBackToPersistedValue() throws {
        let (viewModel, _) = try makeViewModel()
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "launchAtLogin")

        viewModel.launchAtLogin = true
        XCTAssertTrue(viewModel.hasUnsavedChanges)

        viewModel.launchAtLogin = false
        XCTAssertFalse(viewModel.hasUnsavedChanges)

        defaults.removeObject(forKey: "launchAtLogin")
    }

    func testRemoveAllHabits() throws {
        let (viewModel, _) = try makeViewModel()
        viewModel.addHabit(name: "Habit 1", iconName: "target", schedule: .daily)
        viewModel.addHabit(name: "Habit 2", iconName: "book", schedule: .weekly)
        XCTAssertEqual(viewModel.habits.count, 2)

        // Remove all
        while !viewModel.habits.isEmpty {
            viewModel.removeHabit(viewModel.habits[0])
        }
        XCTAssertTrue(viewModel.habits.isEmpty)
        XCTAssertEqual(viewModel.slotCounterText, "0/4 SLOTS ACTIVE")
        XCTAssertTrue(viewModel.canAddSlot)
    }

    // MARK: - Phase 4.1: Completion toggle integration

    func testToggleCompletionTodayAddsAndRemovesCompletion() throws {
        let (viewModel, _) = try makeViewModel()
        let calendar = Self.gregorianCalendar
        let now = Self.date(year: 2026, month: 2, day: 19)

        viewModel.addHabit(name: "Deep Work", iconName: "display", schedule: .daily)
        guard let habit = viewModel.habits.first else {
            XCTFail("Expected habit to exist")
            return
        }

        XCTAssertFalse(viewModel.isCompletedToday(for: habit, now: now, calendar: calendar))

        viewModel.toggleCompletionToday(for: habit, now: now, calendar: calendar)
        XCTAssertTrue(viewModel.isCompletedToday(for: habit, now: now, calendar: calendar))

        viewModel.toggleCompletionToday(for: habit, now: now, calendar: calendar)
        XCTAssertFalse(viewModel.isCompletedToday(for: habit, now: now, calendar: calendar))
    }

    func testToggleCompletionTodayUpdatesStreakSnapshot() throws {
        let (viewModel, _) = try makeViewModel()
        let calendar = Self.gregorianCalendar
        let now = Self.date(year: 2026, month: 2, day: 19)

        viewModel.addHabit(name: "Read", iconName: "book", schedule: .daily)
        guard let habit = viewModel.habits.first else {
            XCTFail("Expected habit to exist")
            return
        }

        let service = HabitStreakService(calendar: calendar, now: now)
        XCTAssertEqual(service.snapshot(for: habit).currentStreak, 0)

        viewModel.toggleCompletionToday(for: habit, now: now, calendar: calendar)
        XCTAssertEqual(service.snapshot(for: habit).currentStreak, 1)
    }

    private static var gregorianCalendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }

    private static func date(year: Int, month: Int, day: Int) -> Date {
        DateComponents(
            calendar: gregorianCalendar,
            timeZone: gregorianCalendar.timeZone,
            year: year,
            month: month,
            day: day,
            hour: 12
        ).date!
    }
}
