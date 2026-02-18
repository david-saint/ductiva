import Foundation
import SwiftData

/// The days of the week used by specific-day schedules.
enum HabitWeekday: Int, Codable, CaseIterable {
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
}

/// Frequency configuration for a habit.
enum HabitSchedule: Codable, Equatable {
    case daily
    case weekly
    case specificDays([HabitWeekday])
}

@Model
final class Habit {
    var name: String
    var createdAt: Date
    var schedule: HabitSchedule
    var completions: [Date]

    init(
        name: String,
        createdAt: Date = Date(),
        schedule: HabitSchedule = .daily,
        completions: [Date] = []
    ) {
        self.name = name
        self.createdAt = createdAt
        self.schedule = schedule
        self.completions = completions
    }
}
