import SwiftUI
import WidgetKit

/// Value snapshot used by widget timeline entries and rendering.
/// Avoids passing live SwiftData models into WidgetKit views.
struct WidgetHabitSnapshot: Identifiable, Hashable, Sendable {
    let id: UUID
    let name: String
    let iconName: String
    let schedule: HabitSchedule
    let completions: [Date]
}

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
    private let ringSize: CGFloat = 52
    private let targetInset: CGFloat = 8

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
            Spacer(minLength: 0)
            slotCell(slots[1])
        }
        .padding(contentPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var twoRowGrid: some View {
        let slots = habitSlots
        return VStack(spacing: 0) {
            HStack(spacing: 0) {
                slotCell(slots[0])
                Spacer(minLength: 0)
                slotCell(slots[1])
            }

            Spacer(minLength: 0)

            HStack(spacing: 0) {
                slotCell(slots[2])
                Spacer(minLength: 0)
                slotCell(slots[3])
            }
        }
        .padding(contentPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var contentPadding: EdgeInsets {
        EdgeInsets(
            top: targetInset - widgetContentMargins.top,
            leading: targetInset - widgetContentMargins.leading,
            bottom: targetInset - widgetContentMargins.bottom,
            trailing: targetInset - widgetContentMargins.trailing
        )
    }

    @ViewBuilder
    private func slotCell(_ habit: WidgetHabitSnapshot?) -> some View {
        if let habit {
            habitCell(habit)
        } else {
            Color.clear
                .frame(width: ringSize, height: ringSize)
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
                .font(.system(size: 19, weight: .medium))
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

// MARK: - Widget Completion Ring

/// A static completion ring sized for widget contexts.
/// Unlike `HabitCompletionRingView`, this does not use `TimelineView`
/// (which is suspended in widgets) and supports configurable sizing.
/// Colors are boosted compared to the in-app ring for visibility at small scale.
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
                // Background track — visible on dark backgrounds
                Circle()
                    .stroke(Color.white.opacity(0.15), lineWidth: 2)

                // Progress arc — boosted opacity for widget readability
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
                    .foregroundStyle(widgetRingColor)
                    .rotationEffect(.degrees(-90))
                    .shadow(color: widgetGlowColor, radius: urgency.glowRadius)
            } else {
                // Completed: bright check ring
                Circle()
                    .stroke(Color.white.opacity(0.4), lineWidth: 2)
            }
        }
        .frame(width: ringSize, height: ringSize)
    }

    /// Widget-specific ring colors with boosted opacity for readability.
    private var widgetRingColor: Color {
        switch urgency {
        case .calm:     return Color.white.opacity(0.55)
        case .warning:  return Color(red: 1.0, green: 0.72, blue: 0.20)
        case .critical: return Color(red: 1.0, green: 0.28, blue: 0.28)
        }
    }

    private var widgetGlowColor: Color {
        switch urgency {
        case .calm:     return .clear
        case .warning:  return Color(red: 1.0, green: 0.60, blue: 0.10).opacity(0.6)
        case .critical: return Color(red: 1.0, green: 0.20, blue: 0.20).opacity(0.7)
        }
    }
}
