import Foundation
import SwiftData

@Observable
final class ConfigurationViewModel {
    static let maxSlots = 4

    var habits: [Habit] = []
    var launchAtLogin: Bool
    var showInMenuBar: Bool

    var activeSlotCount: Int { habits.count }
    var canAddSlot: Bool { habits.count < Self.maxSlots }
    var slotCounterText: String { "\(activeSlotCount)/\(Self.maxSlots) SLOTS ACTIVE" }

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
        } catch {
            habits = []
        }
    }

    /// Adds a new habit slot if under the maximum. Creates via HabitStore and reloads.
    func addHabit(name: String, iconName: String, schedule: HabitSchedule) {
        guard canAddSlot else { return }
        do {
            _ = try habitStore.createHabit(name: name, iconName: iconName, schedule: schedule)
            loadHabits()
        } catch {
            // Creation failed — habits array unchanged
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

    /// Removes a habit slot. Deletes via HabitStore and reloads.
    func removeHabit(_ habit: Habit) {
        do {
            try habitStore.deleteHabit(habit)
            loadHabits()
        } catch {
            // Deletion failed — habits array unchanged
        }
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
