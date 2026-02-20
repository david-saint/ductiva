import Foundation
import SwiftData

@Observable
final class ConfigurationViewModel {
    static let maxSlots = 4

    var habits: [Habit] = []
    var launchAtLogin: Bool
    var showInMenuBar: Bool
    private(set) var errorMessage: String?

    var activeSlotCount: Int { habits.count }
    var canAddSlot: Bool { habits.count < Self.maxSlots }
    var slotCounterText: String { "\(activeSlotCount)/\(Self.maxSlots) SLOTS ACTIVE" }

    /// Whether any settings differ from their persisted UserDefaults values.
    var hasUnsavedChanges: Bool {
        let persistedLaunch = UserDefaults.standard.bool(forKey: "launchAtLogin")
        let persistedMenuBar = UserDefaults.standard.object(forKey: "showInMenuBar") as? Bool ?? true
        return launchAtLogin != persistedLaunch || showInMenuBar != persistedMenuBar
    }

    private let habitStore: HabitStore

    deinit {}

    init(habitStore: HabitStore) {
        self.habitStore = habitStore
        self.launchAtLogin = UserDefaults.standard.bool(forKey: "launchAtLogin")
        self.showInMenuBar = UserDefaults.standard.object(forKey: "showInMenuBar") as? Bool ?? true
    }

    func loadHabits() {
        do {
            habits = try habitStore.fetchHabits()
            clearError()
        } catch {
            habits = []
            setError(prefix: "Loading habits", error: error)
        }
    }

    /// Adds a new habit slot if under the maximum.
    func addHabit(name: String, iconName: String, schedule: HabitSchedule) {
        guard canAddSlot else { return }
        do {
            let habit = try habitStore.createHabit(name: name, iconName: iconName, schedule: schedule)
            insertHabitInOrder(habit)
            clearError()
        } catch {
            setError(prefix: "Adding habit", error: error)
        }
    }

    /// Persists current settings (launchAtLogin, showInMenuBar) to UserDefaults.
    func saveChanges() {
        UserDefaults.standard.set(launchAtLogin, forKey: "launchAtLogin")
        UserDefaults.standard.set(showInMenuBar, forKey: "showInMenuBar")
    }

    /// Reverts in-memory settings to their persisted UserDefaults values and reloads habits.
    func discardChanges() {
        launchAtLogin = UserDefaults.standard.bool(forKey: "launchAtLogin")
        showInMenuBar = UserDefaults.standard.object(forKey: "showInMenuBar") as? Bool ?? true
        loadHabits()
    }

    /// Removes a habit slot.
    func removeHabit(_ habit: Habit) {
        do {
            try habitStore.deleteHabit(habit)
            habits.removeAll { $0.id == habit.id }
            clearError()
        } catch {
            setError(prefix: "Removing habit", error: error)
        }
    }

    /// Returns whether the provided habit has a completion recorded for the supplied day.
    func isCompletedToday(for habit: Habit, now: Date = Date(), calendar: Calendar = .current) -> Bool {
        habitStore.isCompleted(habit, on: now, calendar: calendar)
    }

    /// Toggles a completion entry for the provided habit on the supplied day.
    /// UI is naturally updated because habits is tracked via SwiftData / @Observable.
    func toggleCompletionToday(for habit: Habit, now: Date = Date(), calendar: Calendar = .current) {
        do {
            _ = try habitStore.toggleCompletion(habit, on: now, calendar: calendar)
            clearError()
        } catch {
            setError(prefix: "Updating completion", error: error)
        }
    }

    func habit(withID id: UUID) -> Habit? {
        habits.first(where: { $0.id == id })
    }

    private func insertHabitInOrder(_ habit: Habit) {
        habits.append(habit)
        habits.sort { $0.createdAt > $1.createdAt }
    }

    private func clearError() {
        errorMessage = nil
    }

    private func setError(prefix: String, error: Error) {
        errorMessage = "\(prefix) failed. \(error.localizedDescription)"
    }

    #if DEBUG
    /// Seeds sample habits for testing. Only available in debug builds.
    func seedSampleHabitsIfEmpty() {
        loadHabits()
        guard habits.isEmpty else { return }

        let samples: [(name: String, icon: String, schedule: HabitSchedule)] = [
            ("Deep Work", "display", .daily),
        ]

        for sample in samples {
            _ = try? habitStore.createHabit(
                name: sample.name,
                iconName: sample.icon,
                schedule: sample.schedule
            )
        }

        loadHabits()
    }
    #endif
}
