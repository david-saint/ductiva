import SwiftUI

struct HabitCompletionRingView: View {
    let habit: Habit
    let isCompletedToday: Bool
    
    /// Optional date override. If provided, the ring will strictly render for this date
    /// (useful for widgets where TimelineView is suspended). If nil, uses a self-updating TimelineView.
    var explicitDate: Date? = nil

    @State private var glowPulse = false

    // MARK: - Debug

    /// Set to a non-nil value to compress the time window for visual testing.
    /// e.g. `30` makes a "daily" habit deplete in 30 seconds instead of 24 hours.
    /// Set back to `nil` for production behavior.
    #if DEBUG
    static var debugWindowSeconds: Double? = nil
    #endif

    private var tickInterval: Double {
        #if DEBUG
        return Self.debugWindowSeconds != nil ? 1 : 60
        #else
        return 60
        #endif
    }

    // MARK: - Progress

    private func effectiveProgress(now: Date) -> Double {
        #if DEBUG
        if let window = Self.debugWindowSeconds {
            // Repeating cycle: progress goes 1.0 → 0.0 every `window` seconds, then resets.
            let elapsed = now.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: window)
            return max(0, min(1, 1.0 - elapsed / window))
        }
        #endif
        return Self.ringProgress(schedule: habit.schedule, now: now)
    }

    var body: some View {
        if let explicitDate = explicitDate {
            let progress = effectiveProgress(now: explicitDate)
            let urgency = RingUrgency(progress: progress)
            ringStack(progress: progress, urgency: urgency)
                .frame(width: 24, height: 24)
                .accessibilityHidden(true)
        } else {
            TimelineView(.periodic(from: .now, by: tickInterval)) { context in
                let progress = effectiveProgress(now: context.date)
                let urgency = RingUrgency(progress: progress)
                ringStack(progress: progress, urgency: urgency)
                    .onChange(of: urgency == .critical) { _, isCritical in
                        if isCritical {
                            withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true)) {
                                glowPulse = true
                            }
                        } else {
                            glowPulse = false
                        }
                    }
            }
            .frame(width: 24, height: 24)
            .accessibilityHidden(true)
        }
    }

    @ViewBuilder
    private func ringStack(progress: Double, urgency: RingUrgency) -> some View {
        ZStack {
            if !isCompletedToday {
                // Background track
                Circle()
                    .stroke(StealthCeramicTheme.glassStrokeColor, lineWidth: 1.5)

                // Progress arc
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round))
                    .foregroundStyle(urgency.ringColor)
                    .rotationEffect(.degrees(-90))
                    .shadow(
                        color: urgency.glowColor,
                        radius: glowPulse ? urgency.glowRadius * 1.4 : urgency.glowRadius
                    )
            }

            // Inner icon — existing appearance preserved
            Image(systemName: isCompletedToday ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(
                    isCompletedToday
                        ? Color(red: 0.95, green: 0.99, blue: 1.0)
                        : StealthCeramicTheme.secondaryTextColor.opacity(0.55)
                )
        }
    }

    /// Pure progress calculation — mirrors HabitStreakService calendar conventions.
    /// Returns 1.0 at the start of the window, 0.0 at the end.
    static func ringProgress(
        schedule: HabitSchedule,
        now: Date,
        calendar: Calendar = .current
    ) -> Double {
        switch schedule {
        case .daily, .specificDays:
            guard let interval = calendar.dateInterval(of: .day, for: now) else { return 1.0 }
            let elapsed = now.timeIntervalSince(interval.start)
            return max(0, min(1, 1.0 - elapsed / interval.duration))
        case .weekly:
            guard let interval = calendar.dateInterval(of: .weekOfYear, for: now) else { return 1.0 }
            let elapsed = now.timeIntervalSince(interval.start)
            return max(0, min(1, 1.0 - elapsed / interval.duration))
        }
    }
}

// MARK: - Urgency tier

enum RingUrgency: Equatable {
    case calm, warning, critical

    init(progress: Double) {
        if progress < 0.20 { self = .critical }
        else if progress < 0.40 { self = .warning }
        else { self = .calm }
    }

    var ringColor: Color {
        switch self {
        case .calm:     return Color(red: 0.95, green: 0.99, blue: 1.0).opacity(0.28)
        case .warning:  return Color(red: 1.0, green: 0.72, blue: 0.20)
        case .critical: return Color(red: 1.0, green: 0.28, blue: 0.28)
        }
    }

    var glowColor: Color {
        switch self {
        case .calm:     return .clear
        case .warning:  return Color(red: 1.0, green: 0.60, blue: 0.10).opacity(0.55)
        case .critical: return Color(red: 1.0, green: 0.20, blue: 0.20).opacity(0.70)
        }
    }

    var glowRadius: CGFloat {
        switch self {
        case .calm:     return 0
        case .warning:  return 4
        case .critical: return 7
        }
    }
}
