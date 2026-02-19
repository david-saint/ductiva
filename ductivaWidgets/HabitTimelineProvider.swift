import WidgetKit
import SwiftData
import SwiftUI

struct HabitTimelineEntry: TimelineEntry {
    let date: Date
    let configuration: HabitSelectionIntent
    let habits: [WidgetHabitSnapshot]
    let selectedHabit: WidgetHabitSnapshot?
    let selectedHabitDayStates: [HabitCalendarDayState]?
    let selectedHabitMonthTitle: String?
    let errorMessage: String?
}

struct HabitTimelineProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> HabitTimelineEntry {
        HabitTimelineEntry(date: Date(), configuration: HabitSelectionIntent(), habits: [], selectedHabit: nil, selectedHabitDayStates: nil, selectedHabitMonthTitle: nil, errorMessage: nil)
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
            let data = try await fetchWidgetData(for: configuration)
            return HabitTimelineEntry(
                date: Date(),
                configuration: configuration,
                habits: data.all,
                selectedHabit: data.selected,
                selectedHabitDayStates: data.dayStates,
                selectedHabitMonthTitle: data.monthTitle,
                errorMessage: nil
            )
        } catch {
            print("Widget data fetch failed (\(source), attempt 1): \(String(describing: error))")
        }

        try? await Task.sleep(nanoseconds: 150_000_000)

        do {
            let data = try await fetchWidgetData(for: configuration)
            return HabitTimelineEntry(
                date: Date(),
                configuration: configuration,
                habits: data.all,
                selectedHabit: data.selected,
                selectedHabitDayStates: data.dayStates,
                selectedHabitMonthTitle: data.monthTitle,
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
                selectedHabitDayStates: nil,
                selectedHabitMonthTitle: nil,
                errorMessage: nil
            )
        }
    }
    
    @MainActor
    private func fetchWidgetData(for configuration: HabitSelectionIntent) throws -> (all: [WidgetHabitSnapshot], selected: WidgetHabitSnapshot?, dayStates: [HabitCalendarDayState]?, monthTitle: String?) {
        let container = try SharedContainer.make()
        let context = container.mainContext
        let descriptor = FetchDescriptor<Habit>(sortBy: [SortDescriptor(\.createdAt, order: .forward)])
        let allHabits = try context.fetch(descriptor)
        let calendar = Calendar.current
        let now = Date()
        let streakService = HabitStreakService(calendar: calendar, now: now)
        
        let snapshots = allHabits.map { habit in
            let streakSnapshot = streakService.snapshot(for: habit)
            return WidgetHabitSnapshot(
                id: habit.id,
                name: habit.name,
                iconName: habit.iconName,
                schedule: habit.schedule,
                completions: habit.completions,
                currentStreak: streakSnapshot.currentStreak
            )
        }
        
        var selectedHabit: WidgetHabitSnapshot? = nil
        var dayStates: [HabitCalendarDayState]? = nil
        var monthTitle: String? = nil
        
        if let configHabitID = configuration.habit?.id, configHabitID != "none", let uuid = UUID(uuidString: configHabitID) {
            selectedHabit = snapshots.first(where: { $0.id == uuid })
            if let realHabit = allHabits.first(where: { $0.id == uuid }) {
                var mondayStartCalendar = calendar
                mondayStartCalendar.firstWeekday = 2 // Monday
                let start = mondayStartCalendar.date(from: mondayStartCalendar.dateComponents([.year, .month], from: now)) ?? mondayStartCalendar.startOfDay(for: now)
                monthTitle = start.formatted(.dateTime.month(.wide).year())
                
                if let monthInterval = mondayStartCalendar.dateInterval(of: .month, for: start),
                   let firstGridDate = mondayStartCalendar.dateInterval(of: .weekOfYear, for: monthInterval.start)?.start {
                    dayStates = (0..<42).compactMap { offset in
                        guard let day = mondayStartCalendar.date(byAdding: .day, value: offset, to: firstGridDate) else { return nil }
                        let dayDay = mondayStartCalendar.startOfDay(for: day)
                        let currentMonth = mondayStartCalendar.component(.month, from: start)
                        let currentYear = mondayStartCalendar.component(.year, from: start)
                        let dayMonth = mondayStartCalendar.component(.month, from: dayDay)
                        let dayYear = mondayStartCalendar.component(.year, from: dayDay)
                        return HabitCalendarDayState(
                            date: dayDay,
                            isInDisplayedMonth: currentMonth == dayMonth && currentYear == dayYear,
                            isScheduled: streakService.isScheduled(on: dayDay, for: realHabit),
                            isCompleted: streakService.isCompleted(on: dayDay, for: realHabit),
                            isToday: mondayStartCalendar.isDate(dayDay, inSameDayAs: now)
                        )
                    }
                }
            }
        }
        
        return (snapshots, selectedHabit, dayStates, monthTitle)
    }
}
