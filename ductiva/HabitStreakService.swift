import Foundation

struct HabitStreakSnapshot {
    let currentStreak: Int
    let perfectDays: Int
    let fireVisualActive: Bool
}

struct HabitStreakService {
    let calendar: Calendar
    let now: Date

    init(calendar: Calendar = .current, now: Date = Date()) {
        self.calendar = calendar
        self.now = now
    }

    func snapshot(for habit: Habit) -> HabitStreakSnapshot {
        let schedule = habit.schedule
        let completionDays = normalizedCompletionDays(for: habit)
        let currentStreak = calculateCurrentStreak(for: habit, schedule: schedule, completionDays: completionDays)
        let perfectDays = completionDays.count
        let fireVisualActive = isFireVisualActive(schedule: schedule, currentStreak: currentStreak)

        return HabitStreakSnapshot(
            currentStreak: currentStreak,
            perfectDays: perfectDays,
            fireVisualActive: fireVisualActive
        )
    }

    func isScheduled(on date: Date, schedule: HabitSchedule) -> Bool {
        let weekday = calendar.component(.weekday, from: date)

        switch schedule {
        case .daily:
            return true
        case .weekly:
            return true
        case let .specificDays(days):
            return days.contains { $0.rawValue == weekday }
        }
    }
    
    // Legacy method for compatibility if needed, but we should prefer passing `schedule`
    func isScheduled(on date: Date, for habit: Habit) -> Bool {
        isScheduled(on: date, schedule: habit.schedule)
    }

    func isCompleted(on date: Date, for habit: Habit) -> Bool {
        normalizedCompletionDays(for: habit).contains(calendar.startOfDay(for: date))
    }
    
    func isCompleted(on date: Date, completionDays: Set<Date>) -> Bool {
        completionDays.contains(calendar.startOfDay(for: date))
    }

    func normalizedCompletionDays(for habit: Habit) -> Set<Date> {
        Set(habit.completions.map { calendar.startOfDay(for: $0) })
    }

    private func calculateCurrentStreak(for habit: Habit, schedule: HabitSchedule, completionDays: Set<Date>) -> Int {
        if case .weekly = schedule {
            return calculateWeeklyStreak(for: habit, completionDays: completionDays)
        }

        let today = calendar.startOfDay(for: now)
        let createdDay = calendar.startOfDay(for: habit.createdAt)

        var streak = 0
        var cursor = today

        if isScheduled(on: cursor, schedule: schedule), completionDays.contains(cursor) {
            streak += 1
        }

        if let previousDay = calendar.date(byAdding: .day, value: -1, to: cursor) {
            cursor = previousDay
        }

        while cursor >= createdDay {
            if isScheduled(on: cursor, schedule: schedule) {
                if completionDays.contains(cursor) {
                    streak += 1
                } else {
                    break
                }
            }

            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: cursor) else {
                break
            }
            cursor = previousDay
        }

        return streak
    }

    private func calculateWeeklyStreak(for habit: Habit, completionDays: Set<Date>) -> Int {
        let today = calendar.startOfDay(for: now)
        let createdDay = calendar.startOfDay(for: habit.createdAt)

        guard var weekInterval = calendar.dateInterval(of: .weekOfYear, for: today) else {
            return 0
        }

        var streak = 0

        if hasCompletion(inWeekContaining: weekInterval.start, completionDays: completionDays) {
            streak += 1
        }

        while let previousWeekStart = calendar.date(byAdding: .weekOfYear, value: -1, to: weekInterval.start) {
            guard let previousWeekInterval = calendar.dateInterval(of: .weekOfYear, for: previousWeekStart) else {
                break
            }

            if previousWeekInterval.end < createdDay {
                break
            }

            if hasCompletion(inWeekContaining: previousWeekInterval.start, completionDays: completionDays) {
                streak += 1
            } else {
                break
            }

            weekInterval = previousWeekInterval
        }

        return streak
    }

    private func hasCompletion(inWeekContaining date: Date, completionDays: Set<Date>) -> Bool {
        completionDays.contains {
            calendar.isDate($0, equalTo: date, toGranularity: .weekOfYear)
        }
    }

    private func isFireVisualActive(schedule: HabitSchedule, currentStreak: Int) -> Bool {
        switch schedule {
        case .daily:
            return currentStreak >= 5
        case .weekly:
            return currentStreak >= 3
        case let .specificDays(days):
            let daysPerWeek = max(1, Set(days).count)
            return currentStreak >= daysPerWeek * 3
        }
    }
}
