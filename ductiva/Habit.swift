import Foundation
import SwiftData

/// The days of the week used by specific-day schedules.
enum HabitWeekday: Int, CaseIterable {
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
}

/// Frequency configuration for a habit.
enum HabitSchedule: Equatable {
    case daily
    case weekly
    case specificDays([HabitWeekday])
}

@Model
final class Habit {
    var name: String
    var createdAt: Date
    private var scheduleTypeRaw: String
    private var scheduleDaysRaw: [Int]
    var completions: [Date]

    @Transient
    var schedule: HabitSchedule {
        get {
            switch scheduleTypeRaw {
            case "daily":
                return .daily
            case "weekly":
                return .weekly
            case "specificDays":
                let days = scheduleDaysRaw.compactMap(HabitWeekday.init(rawValue:))
                return .specificDays(days)
            default:
                return .daily
            }
        }
        set {
            switch newValue {
            case .daily:
                scheduleTypeRaw = "daily"
                scheduleDaysRaw = []
            case .weekly:
                scheduleTypeRaw = "weekly"
                scheduleDaysRaw = []
            case let .specificDays(days):
                scheduleTypeRaw = "specificDays"
                scheduleDaysRaw = days.map(\.rawValue)
            }
        }
    }

    init(
        name: String,
        createdAt: Date = Date(),
        schedule: HabitSchedule = .daily,
        completions: [Date] = []
    ) {
        self.name = name
        self.createdAt = createdAt
        self.scheduleTypeRaw = "daily"
        self.scheduleDaysRaw = []
        self.completions = completions
        self.schedule = schedule
    }
}
