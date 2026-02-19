import WidgetKit
import SwiftUI
import AppIntents

struct DuctivaWidgets: Widget {
    let kind: String = "ductivaWidgets"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: HabitSelectionIntent.self, provider: HabitTimelineProvider()) { entry in
            DuctivaWidgetEntryView(entry: entry)
                .widgetLiquidGlassBackground()
        }
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        .contentMarginsDisabled()
    }
}

struct DuctivaWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    var entry: HabitTimelineProvider.Entry

    var body: some View {
        if let error = entry.errorMessage {
            errorView(error)
        } else {
            switch family {
            case .systemSmall:
                smallWidget
            case .systemMedium:
                mediumWidget
            case .systemLarge:
                largeWidget
            default:
                smallWidget
            }
        }
    }

    // MARK: - Small Widget

    @ViewBuilder
    private var smallWidget: some View {
        if let habit = entry.selectedHabit {
            SmallFocusWidgetView(habit: habit, currentDate: entry.date)
        } else {
            SmallStandardWidgetView(habits: entry.habits, currentDate: entry.date)
        }
    }

    // MARK: - Medium Widget

    @ViewBuilder
    private var mediumWidget: some View {
        MediumSummaryWidgetView(habits: entry.habits, currentDate: entry.date)
    }

    // MARK: - Large Widget

    @ViewBuilder
    private var largeWidget: some View {
        if let habit = entry.selectedHabit {
            LargeFocusWidgetView(habit: habit, dayStates: entry.selectedHabitDayStates, monthTitle: entry.selectedHabitMonthTitle, currentDate: entry.date)
        } else {
            LargeStandardWidgetView(habits: entry.habits, currentDate: entry.date)
        }
    }

    // MARK: - Error

    private func errorView(_ message: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 20))
                .foregroundStyle(StealthCeramicTheme.secondaryTextColor.opacity(0.5))
            Text("ERROR")
                .font(.system(size: 9, weight: .medium, design: .monospaced))
                .foregroundStyle(StealthCeramicTheme.secondaryTextColor.opacity(0.5))
        }
    }
}
