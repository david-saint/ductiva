import WidgetKit
import SwiftData
import SwiftUI

struct HabitTimelineEntry: TimelineEntry {
    let date: Date
    let configuration: HabitSelectionIntent
    let habits: [WidgetHabitSnapshot]
    let selectedHabit: WidgetHabitSnapshot?
    let errorMessage: String?
}

struct HabitTimelineProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> HabitTimelineEntry {
        HabitTimelineEntry(date: Date(), configuration: HabitSelectionIntent(), habits: [], selectedHabit: nil, errorMessage: nil)
    }

    func snapshot(for configuration: HabitSelectionIntent, in context: Context) async -> HabitTimelineEntry {
        await loadEntry(for: configuration, source: "snapshot")
    }
    
    func timeline(for configuration: HabitSelectionIntent, in context: Context) async -> Timeline<HabitTimelineEntry> {
        let entry = await loadEntry(for: configuration, source: "timeline")
        
        let calendar = Calendar.current
        let tomorrow = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: Date())!)
        
        return Timeline(entries: [entry], policy: .after(tomorrow))
    }

    private func loadEntry(for configuration: HabitSelectionIntent, source: String) async -> HabitTimelineEntry {
        do {
            let (allHabits, selected) = try await fetchWidgetData(for: configuration)
            return HabitTimelineEntry(
                date: Date(),
                configuration: configuration,
                habits: allHabits,
                selectedHabit: selected,
                errorMessage: nil
            )
        } catch {
            print("Widget data fetch failed (\(source), attempt 1): \(String(describing: error))")
        }

        try? await Task.sleep(nanoseconds: 150_000_000)

        do {
            let (allHabits, selected) = try await fetchWidgetData(for: configuration)
            return HabitTimelineEntry(
                date: Date(),
                configuration: configuration,
                habits: allHabits,
                selectedHabit: selected,
                errorMessage: nil
            )
        } catch {
            print("Widget data fetch failed (\(source), attempt 2): \(String(describing: error))")
            // Fall back to the standard empty state instead of surfacing transient storage errors.
            return HabitTimelineEntry(
                date: Date(),
                configuration: configuration,
                habits: [],
                selectedHabit: nil,
                errorMessage: nil
            )
        }
    }
    
    @MainActor
    private func fetchWidgetData(for configuration: HabitSelectionIntent) throws -> (all: [WidgetHabitSnapshot], selected: WidgetHabitSnapshot?) {
        let container = try SharedContainer.make()
        let context = container.mainContext
        let descriptor = FetchDescriptor<Habit>(sortBy: [SortDescriptor(\.createdAt, order: .forward)])
        let allHabits = try context.fetch(descriptor)
        let snapshots = allHabits.map { habit in
            WidgetHabitSnapshot(
                id: habit.id,
                name: habit.name,
                iconName: habit.iconName,
                schedule: habit.schedule,
                completions: habit.completions
            )
        }
        
        var selectedHabit: WidgetHabitSnapshot? = nil
        if let configHabitID = configuration.habit?.id, configHabitID != "none", let uuid = UUID(uuidString: configHabitID) {
            selectedHabit = snapshots.first(where: { $0.id == uuid })
        }
        
        return (snapshots, selectedHabit)
    }
}
