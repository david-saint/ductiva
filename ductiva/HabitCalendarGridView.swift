import SwiftUI

struct HabitCalendarGridView: View {
    let monthTitle: String
    let dayStates: [HabitCalendarDayState]
    var onShowPreviousMonth: () -> Void
    var onShowNextMonth: () -> Void

    private let weekdaySymbols = ["M", "T", "W", "T", "F", "S", "S"]

    var body: some View {
        VStack(spacing: 0) {
            header
            Spacer().frame(height: 22)
            weekdayLegend
            Spacer().frame(height: 14)
            dayDotsGrid
        }
    }

    private var header: some View {
        HStack {
            Button(action: onShowPreviousMonth) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(StealthCeramicTheme.primaryTextColor)
                    .frame(width: 20, height: 20)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Show previous month")

            Spacer()

            Text(monthTitle.uppercased())
                .font(.system(size: 16, weight: .medium, design: .monospaced))
                .tracking(StealthCeramicTheme.headerTracking)
                .foregroundStyle(StealthCeramicTheme.primaryTextColor)

            Spacer()

            Button(action: onShowNextMonth) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(StealthCeramicTheme.primaryTextColor)
                    .frame(width: 20, height: 20)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Show next month")
        }
    }

    private var weekdayLegend: some View {
        HStack(spacing: 0) {
            ForEach(Array(weekdaySymbols.enumerated()), id: \.offset) { _, symbol in
                Text(symbol)
                    .font(.system(size: 11, weight: .medium, design: .monospaced))
                    .foregroundStyle(StealthCeramicTheme.secondaryTextColor.opacity(0.45))
                    .frame(maxWidth: .infinity)
            }
        }
    }

    private var dayDotsGrid: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(minimum: 18), spacing: 0), count: 7),
            spacing: 16
        ) {
            ForEach(dayStates) { state in
                HabitCalendarDayDotView(state: state)
                    .frame(height: 14)
            }
        }
    }
}

private struct HabitCalendarDayDotView: View {
    let state: HabitCalendarDayState

    var body: some View {
        Group {
            if state.isInDisplayedMonth && state.isScheduled {
                Circle()
                    .fill(state.isCompleted ? Color.white : Color.white.opacity(0.2))
                    .frame(width: state.isToday ? 8 : 6, height: state.isToday ? 8 : 6)
                    .overlay {
                        if state.isToday {
                            Circle()
                                .stroke(Color.white.opacity(0.85), lineWidth: 1)
                                .frame(width: 14, height: 14)
                        }
                    }
                    .shadow(color: state.isCompleted ? Color.white.opacity(0.4) : .clear, radius: 3, y: 0)
                    .accessibilityElement()
                    .accessibilityLabel(accessibilityLabel)
            } else {
                Color.clear
                    .frame(width: 14, height: 14)
                    .accessibilityHidden(true)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var accessibilityLabel: String {
        let dateText = state.date.formatted(.dateTime.month(.wide).day().year())
        let scheduledText = state.isScheduled ? "scheduled" : "not scheduled"
        let completionText = state.isCompleted ? "completed" : "not completed"
        let todayText = state.isToday ? ", today" : ""
        return "\(dateText), \(scheduledText), \(completionText)\(todayText)"
    }
}
