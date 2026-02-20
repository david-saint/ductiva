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
    let currentStreak: Int
}

extension WidgetHabitSnapshot {
    func isScheduled(on date: Date) -> Bool {
        switch schedule {
        case .daily, .weekly:
            return true
        case .specificDays(let days):
            let weekday = Calendar.current.component(.weekday, from: date)
            return days.contains { $0.rawValue == weekday }
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
    var lineWidth: CGFloat = 4.5

    private var urgency: RingUrgency {
        RingUrgency(progress: progress)
    }

    var body: some View {
        ZStack {
            if !isCompleted {
                // Background track — visible on dark backgrounds
                Circle()
                    .stroke(Color.white.opacity(0.15), lineWidth: lineWidth)

                // Progress arc — boosted opacity for widget readability
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(style: StrokeStyle(lineWidth: lineWidth + 0.5, lineCap: .round))
                    .foregroundStyle(widgetRingColor)
                    .rotationEffect(.degrees(-90))
                    .shadow(color: widgetGlowColor, radius: urgency.glowRadius)
            } else {
                // Completed: bright check ring
                Circle()
                    .stroke(Color.white.opacity(0.4), lineWidth: lineWidth)
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
