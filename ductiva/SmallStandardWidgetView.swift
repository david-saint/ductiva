import SwiftUI

/// A 2x2 grid widget view displaying up to 4 habits with their completion rings.
/// Used in the `.systemSmall` widget family when no specific habit is focused.
///
/// Design: Each cell shows the habit's SF Symbol icon centered inside an
/// `HabitCompletionRingView`. The grid is evenly spaced across the widget surface
/// following the "Stealth Ceramic" aesthetic.
struct SmallStandardWidgetView: View {
    let habits: [Habit]
    let currentDate: Date

    /// The habits actually rendered (capped at 4).
    var displayedHabits: [Habit] {
        Array(habits.prefix(4))
    }

    /// Number of rows needed for a 2-column grid.
    var gridRows: Int {
        let count = displayedHabits.count
        guard count > 0 else { return 0 }
        return (count + 1) / 2   // ceil(count / 2)
    }

    /// Whether a habit has a completion logged for `currentDate`.
    func isCompleted(_ habit: Habit) -> Bool {
        let calendar = Calendar.current
        let targetDay = calendar.startOfDay(for: currentDate)
        return habit.completions.contains { completion in
            calendar.isDate(completion, inSameDayAs: targetDay)
        }
    }

    // MARK: - Body

    var body: some View {
        if displayedHabits.isEmpty {
            emptyState
        } else {
            gridContent
        }
    }

    // MARK: - Grid

    @ViewBuilder
    private var gridContent: some View {
        let columns = [
            GridItem(.flexible(), spacing: 8),
            GridItem(.flexible(), spacing: 8),
        ]

        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(displayedHabits, id: \.id) { habit in
                habitCell(habit)
            }
        }
        .padding(12)
    }

    @ViewBuilder
    private func habitCell(_ habit: Habit) -> some View {
        let completed = isCompleted(habit)

        ZStack {
            // Completion ring — sized up for the widget cell
            WidgetCompletionRing(
                progress: HabitCompletionRingView.ringProgress(
                    schedule: habit.schedule,
                    now: currentDate
                ),
                isCompleted: completed,
                ringSize: 44
            )

            // Habit icon
            Image(systemName: habit.iconName)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(
                    completed
                        ? Color(red: 0.95, green: 0.99, blue: 1.0)
                        : StealthCeramicTheme.secondaryTextColor
                )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(habit.name), \(completed ? "completed" : "not completed")")
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 6) {
            Image(systemName: "plus.circle.dashed")
                .font(.system(size: 24, weight: .light))
                .foregroundStyle(StealthCeramicTheme.secondaryTextColor.opacity(0.5))
            Text("NO HABITS")
                .font(.system(size: 9, weight: .medium))
                .tracking(StealthCeramicTheme.headerTracking)
                .foregroundStyle(StealthCeramicTheme.secondaryTextColor.opacity(0.5))
        }
    }
}

// MARK: - Widget Completion Ring

/// A static completion ring sized for widget contexts.
/// Unlike `HabitCompletionRingView`, this does not use `TimelineView`
/// (which is suspended in widgets) and supports configurable sizing.
struct WidgetCompletionRing: View {
    let progress: Double
    let isCompleted: Bool
    var ringSize: CGFloat = 44

    private var urgency: RingUrgency {
        RingUrgency(progress: progress)
    }

    var body: some View {
        ZStack {
            if !isCompleted {
                // Background track
                Circle()
                    .stroke(StealthCeramicTheme.glassStrokeColor, lineWidth: 2)

                // Progress arc
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
                    .foregroundStyle(urgency.ringColor)
                    .rotationEffect(.degrees(-90))
                    .shadow(color: urgency.glowColor, radius: urgency.glowRadius)
            } else {
                // Completed state: subtle filled ring
                Circle()
                    .stroke(Color(red: 0.95, green: 0.99, blue: 1.0).opacity(0.3), lineWidth: 2)
            }
        }
        .frame(width: ringSize, height: ringSize)
    }
}
