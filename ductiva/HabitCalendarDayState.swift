import Foundation

struct HabitCalendarDayState: Identifiable, Sendable {
    let date: Date
    let isInDisplayedMonth: Bool
    let isScheduled: Bool
    let isCompleted: Bool
    let isToday: Bool

    var id: Date { date }
}
