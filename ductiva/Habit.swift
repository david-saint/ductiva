import Foundation
import SwiftData

/// The days of the week used by specific-day schedules.
enum HabitWeekday: Int, CaseIterable, Codable, Hashable, Sendable {
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7

    var shortName: String {
        switch self {
        case .sunday: return "Su"
        case .monday: return "M"
        case .tuesday: return "Tu"
        case .wednesday: return "W"
        case .thursday: return "Th"
        case .friday: return "F"
        case .saturday: return "Sa"
        }
    }
}

/// Frequency configuration for a habit.
enum HabitSchedule: Equatable, Codable, Hashable, Sendable {
    case daily
    case weekly
    case specificDays([HabitWeekday])

    var localizedDescription: String {
        switch self {
        case .daily:
            return "Daily"
        case .weekly:
            return "Weekly"
        case let .specificDays(days):
            if days.count == 7 {
                return "Daily"
            }
            let sortedDays = days.sorted { $0.rawValue < $1.rawValue }
            let dayStrings = sortedDays.map(\.shortName).joined(separator: ", ")
            return "Every \(dayStrings)"
        }
    }
}

@Model
final class Habit {
    var id: UUID
    var name: String
    var iconName: String
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
        id: UUID = UUID(),
        name: String,
        iconName: String = "target",
        createdAt: Date = Date(),
        schedule: HabitSchedule = .daily,
        completions: [Date] = []
    ) {
        self.id = id
        self.name = name
        self.iconName = iconName
        self.createdAt = createdAt
        self.scheduleTypeRaw = "daily"
        self.scheduleDaysRaw = []
        self.completions = completions
        self.schedule = schedule
    }
}
