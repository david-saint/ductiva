import SwiftUI

struct HabitMetricsView: View {
    let snapshot: HabitStreakSnapshot

    @State private var animateFlame = false

    var body: some View {
        HStack(spacing: 0) {
            metricPane(
                title: "CURRENT STREAK",
                value: snapshot.currentStreak,
                unit: "DAYS",
                showsFlame: snapshot.fireVisualActive
            )

            Rectangle()
                .fill(StealthCeramicTheme.dividerColor)
                .frame(width: 1)

            metricPane(
                title: "PERFECT DAYS",
                value: snapshot.perfectDays,
                unit: "TOTAL",
                showsFlame: false
            )
        }
        .frame(maxWidth: .infinity)
        .frame(height: 104)
        .onAppear {
            guard snapshot.fireVisualActive else { return }
            withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
                animateFlame = true
            }
        }
    }

    private func metricPane(title: String, value: Int, unit: String, showsFlame: Bool) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                Text(title)
                    .font(.system(size: 11, weight: .medium))
                    .tracking(StealthCeramicTheme.headerTracking)
                    .foregroundStyle(StealthCeramicTheme.secondaryTextColor)
                if showsFlame {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(Color(red: 1.0, green: 0.47, blue: 0.12))
                        .scaleEffect(animateFlame ? 1.05 : 0.85)
                        .shadow(color: Color(red: 1.0, green: 0.37, blue: 0.0).opacity(0.5), radius: 5)
                }
            }

            HStack(alignment: .lastTextBaseline, spacing: 7) {
                Text("\(value)")
                    .font(.system(size: 38, weight: .medium))
                    .foregroundStyle(
                        showsFlame
                            ? Color(red: 1.0, green: 0.52, blue: 0.18)
                            : StealthCeramicTheme.primaryTextColor
                    )
                Text(unit)
                    .font(.system(size: 11, weight: .medium))
                    .tracking(StealthCeramicTheme.counterTracking)
                    .foregroundStyle(StealthCeramicTheme.secondaryTextColor.opacity(0.55))
            }
        }
        .padding(.horizontal, 22)
        .padding(.top, 14)
        .padding(.bottom, 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(title) \(value) \(unit)")
    }
}
