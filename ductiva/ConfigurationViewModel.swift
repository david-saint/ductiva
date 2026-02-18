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

    #if DEBUG
    /// Seeds sample habits for testing. Only available in debug builds.
    func seedSampleHabitsIfEmpty() {
        loadHabits()
        guard habits.isEmpty else { return }

        let samples: [(name: String, icon: String, schedule: HabitSchedule)] = [
            ("Deep Work", "display", .daily),
            ("Strength Training", "dumbbell", .daily),
            ("Side Project", "chevron.left.forwardslash.chevron.right", .weekly),
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
