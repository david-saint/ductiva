import SwiftUI
import WidgetKit

/// A 2x2 grid widget view displaying up to 4 habits with their completion rings.
/// Used in the `.systemSmall` widget family when no specific habit is focused.
///
/// Design reference: "SMALL WIDGET (4 HABITS)" from Widgets.png —
/// each cell shows the habit's SF Symbol icon centered inside a completion ring.
/// The grid is evenly spaced across the widget surface following "Stealth Ceramic".
struct SmallStandardWidgetView: View {
    @Environment(\.widgetContentMargins) private var widgetContentMargins

    let habits: [WidgetHabitSnapshot]
    let currentDate: Date
    private let ringSize: CGFloat = 60

    /// The habits actually rendered (capped at 4).
    var displayedHabits: [WidgetHabitSnapshot] {
        Array(habits.prefix(4))
    }

    /// Number of rows needed for a 2-column grid.
    var gridRows: Int {
        let count = displayedHabits.count
        guard count > 0 else { return 0 }
        return (count + 1) / 2   // ceil(count / 2)
    }

    /// Whether a habit has a completion logged for `currentDate`.
    func isCompleted(_ habit: WidgetHabitSnapshot) -> Bool {
        habit.isCompleted(on: currentDate)
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
        if gridRows == 1 {
            singleRowGrid
        } else {
            twoRowGrid
        }
    }

    private var habitSlots: [WidgetHabitSnapshot?] {
        var slots = displayedHabits.map(Optional.some)
        while slots.count < 4 {
            slots.append(nil)
        }
        return slots
    }

    private var singleRowGrid: some View {
        let slots = habitSlots
        return HStack(spacing: 0) {
            slotCell(slots[0])
            slotCell(slots[1])
        }
        .padding(4)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var twoRowGrid: some View {
        let slots = habitSlots
        return VStack(spacing: 0) {
            HStack(spacing: 0) {
                slotCell(slots[0])
                slotCell(slots[1])
            }

            HStack(spacing: 0) {
                slotCell(slots[2])
                slotCell(slots[3])
            }
        }
        .padding(4)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private func slotCell(_ habit: WidgetHabitSnapshot?) -> some View {
        if let habit {
            if let url = WidgetDeepLink.habitURL(for: habit.id) {
                Link(destination: url) {
                    habitCell(habit)
                }
            } else {
                habitCell(habit)
            }
        } else {
            Color.clear
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .accessibilityHidden(true)
        }
    }

    @ViewBuilder
    private func habitCell(_ habit: WidgetHabitSnapshot) -> some View {
        let completed = isCompleted(habit)

        ZStack {
            // Completion ring
            WidgetCompletionRing(
                progress: HabitCompletionRingView.ringProgress(
                    schedule: habit.schedule,
                    now: currentDate
                ),
                isCompleted: completed,
                ringSize: ringSize
            )

            // Habit icon
            Image(systemName: habit.iconName)
                .font(.system(size: 22, weight: .medium))
                .foregroundStyle(
                    completed
                        ? Color.white
                        : Color.white.opacity(0.7)
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
                .foregroundStyle(Color.white.opacity(0.35))
            Text("NO HABITS")
                .font(.system(size: 9, weight: .medium))
                .tracking(StealthCeramicTheme.headerTracking)
                .foregroundStyle(Color.white.opacity(0.35))
        }
    }
}
