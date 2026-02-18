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
}
