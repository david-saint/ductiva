import Foundation
import SwiftData
#if canImport(WidgetKit)
import WidgetKit
#endif

struct HabitStore {
    let modelContext: ModelContext
    private let widgetKind = AppConfiguration.widgetKind

    func createHabit(
        name: String,
        iconName: String = "target",
        schedule: HabitSchedule,
        createdAt: Date = Date(),
        completions: [Date] = []
    ) throws -> Habit {
        let habit = Habit(
            name: name,
            iconName: iconName,
            createdAt: createdAt,
            schedule: schedule,
            completions: completions
        )
        modelContext.insert(habit)
        try modelContext.save()
        reloadWidgetTimelines()
        return habit
    }

    func fetchHabits() throws -> [Habit] {
        let descriptor = FetchDescriptor<Habit>(sortBy: [SortDescriptor(\Habit.createdAt, order: .reverse)])
        return try modelContext.fetch(descriptor)
    }

    func updateHabit(_ habit: Habit, name: String? = nil, schedule: HabitSchedule? = nil) throws {
        if let name {
            habit.name = name
        }

        if let schedule {
            habit.schedule = schedule
        }

        try modelContext.save()
        reloadWidgetTimelines()
    }

    func deleteHabit(_ habit: Habit) throws {
        modelContext.delete(habit)
        try modelContext.save()
        reloadWidgetTimelines()
    }

    func isCompleted(_ habit: Habit, on date: Date = Date(), calendar: Calendar = .current) -> Bool {
        let targetDay = calendar.startOfDay(for: date)
        return habit.completions.contains { completionDate in
            calendar.isDate(completionDate, inSameDayAs: targetDay)
        }
    }

    @discardableResult
    func toggleCompletion(_ habit: Habit, on date: Date = Date(), calendar: Calendar = .current) throws -> Bool {
        let targetDay = calendar.startOfDay(for: date)

        if let index = habit.completions.firstIndex(where: { calendar.isDate($0, inSameDayAs: targetDay) }) {
            habit.completions.remove(at: index)
            try modelContext.save()
            reloadWidgetTimelines()
            return false
        }

        habit.completions.append(targetDay)
        try modelContext.save()
        reloadWidgetTimelines()
        return true
    }

    private func reloadWidgetTimelines() {
        #if canImport(WidgetKit)
        WidgetCenter.shared.reloadTimelines(ofKind: widgetKind)
        #endif
    }
}
