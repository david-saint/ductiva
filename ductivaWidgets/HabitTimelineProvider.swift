import WidgetKit
import SwiftData
import SwiftUI

struct HabitTimelineEntry: TimelineEntry {
    let date: Date
    let configuration: HabitSelectionIntent
    let habits: [Habit]
    let selectedHabit: Habit?
    let errorMessage: String?
}

struct HabitTimelineProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> HabitTimelineEntry {
        HabitTimelineEntry(date: Date(), configuration: HabitSelectionIntent(), habits: [], selectedHabit: nil, errorMessage: nil)
    }

    func snapshot(for configuration: HabitSelectionIntent, in context: Context) async -> HabitTimelineEntry {
        do {
            let (allHabits, selected) = try await fetchWidgetData(for: configuration)
            return HabitTimelineEntry(date: Date(), configuration: configuration, habits: allHabits, selectedHabit: selected, errorMessage: nil)
        } catch {
            return HabitTimelineEntry(date: Date(), configuration: configuration, habits: [], selectedHabit: nil, errorMessage: error.localizedDescription)
        }
    }
    
    func timeline(for configuration: HabitSelectionIntent, in context: Context) async -> Timeline<HabitTimelineEntry> {
        let entry: HabitTimelineEntry
        do {
            let (allHabits, selected) = try await fetchWidgetData(for: configuration)
            entry = HabitTimelineEntry(date: Date(), configuration: configuration, habits: allHabits, selectedHabit: selected, errorMessage: nil)
        } catch {
            entry = HabitTimelineEntry(date: Date(), configuration: configuration, habits: [], selectedHabit: nil, errorMessage: error.localizedDescription)
        }
        
        let calendar = Calendar.current
        let tomorrow = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: Date())!)
        
        return Timeline(entries: [entry], policy: .after(tomorrow))
    }
    
    @MainActor
    private func fetchWidgetData(for configuration: HabitSelectionIntent) throws -> (all: [Habit], selected: Habit?) {
        let container = try SharedContainer.make()
        let context = container.mainContext
        let descriptor = FetchDescriptor<Habit>(sortBy: [SortDescriptor(\.createdAt, order: .forward)])
        let allHabits = try context.fetch(descriptor)
        
        var selectedHabit: Habit? = nil
        if let configHabitID = configuration.habit?.id, let uuid = UUID(uuidString: configHabitID) {
            selectedHabit = allHabits.first(where: { $0.id == uuid })
        }
        
        return (allHabits, selectedHabit)
    }
}