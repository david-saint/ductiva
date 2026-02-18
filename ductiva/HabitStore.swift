import Foundation
import SwiftData

struct HabitStore {
    let modelContext: ModelContext

    func createHabit(
        name: String,
        schedule: HabitSchedule,
        createdAt: Date = Date(),
        completions: [Date] = []
    ) throws -> Habit {
        let habit = Habit(
            name: name,
            createdAt: createdAt,
            schedule: schedule,
            completions: completions
        )
        modelContext.insert(habit)
        try modelContext.save()
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
    }

    func deleteHabit(_ habit: Habit) throws {
        modelContext.delete(habit)
        try modelContext.save()
    }
}
