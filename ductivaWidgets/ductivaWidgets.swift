import WidgetKit
import SwiftUI
import AppIntents

struct DuctivaWidgets: Widget {
    let kind: String = "ductivaWidgets"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: HabitSelectionIntent.self, provider: HabitTimelineProvider()) { entry in
            ductivaWidgetsEntryView(entry: entry)
                .widgetLiquidGlassBackground()
        }
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct ductivaWidgetsEntryView : View {
    var entry: HabitTimelineProvider.Entry

    var body: some View {
        VStack {
            if let error = entry.errorMessage {
                Text("Error: \(error)").font(.caption).foregroundColor(.red)
            } else if let habit = entry.selectedHabit {
                Text("Focused on: \(habit.name)")
            } else {
                Text("All Habits (\(entry.habits.count))")
            }
        }
    }
}
