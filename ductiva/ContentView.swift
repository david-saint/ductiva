//
//  ContentView.swift
//  ductiva
//
//  Created by David Saint on 18/02/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    static let habitsFetchDescriptor = FetchDescriptor<Habit>(
        sortBy: [SortDescriptor(\Habit.createdAt, order: .reverse)]
    )

    @Query(Self.habitsFetchDescriptor) private var habits: [Habit]

    var body: some View {
        NavigationSplitView {
            List(habits) { habit in
                VStack(alignment: .leading, spacing: 4) {
                    Text(habit.name)
                        .font(.headline)
                    Text(Self.scheduleDescription(for: habit.schedule))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .overlay {
                if habits.isEmpty {
                    ContentUnavailableView(
                        "No Habits Yet",
                        systemImage: "target",
                        description: Text("Create your first habit to begin tracking.")
                    )
                }
            }
            .navigationTitle("Habits")
            .navigationSplitViewColumnWidth(min: 220, ideal: 280)
        } detail: {
            if let selectedHabit = habits.first {
                VStack(alignment: .leading, spacing: 8) {
                    Text(selectedHabit.name)
                        .font(.title2)
                    Text(Self.scheduleDescription(for: selectedHabit.schedule))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding()
            } else {
                Text("Select a habit")
            }
        }
    }

    nonisolated static func scheduleDescription(for schedule: HabitSchedule) -> String {
        switch schedule {
        case .daily:
            return "Daily"
        case .weekly:
            return "Weekly"
        case let .specificDays(days):
            if days.isEmpty {
                return "Specific Days"
            }
            return days.map(Self.weekdayAbbreviation).joined(separator: ", ")
        }
    }

    nonisolated private static func weekdayAbbreviation(for day: HabitWeekday) -> String {
        switch day {
        case .sunday:
            return "Sun"
        case .monday:
            return "Mon"
        case .tuesday:
            return "Tue"
        case .wednesday:
            return "Wed"
        case .thursday:
            return "Thu"
        case .friday:
            return "Fri"
        case .saturday:
            return "Sat"
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Habit.self, inMemory: true)
}
