import SwiftUI
import SwiftData

struct ConfigurationView: View {
    @State var viewModel: ConfigurationViewModel

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    StealthCeramicTheme.chassisColor,
                    StealthCeramicTheme.chassisColor.opacity(0.86),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                headerSection
                Spacer().frame(height: 20)
                slotListSection
                Spacer().frame(height: 16)
                settingsDivider
                Spacer().frame(height: 12)
                settingsSection
                Spacer()
                actionBar
            }
            .padding(24)
        }
        .onAppear {
            viewModel.loadHabits()
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack {
            Text("CONFIGURATION")
                .font(.title3.bold())
                .tracking(4)
                .foregroundStyle(StealthCeramicTheme.primaryTextColor)
            Spacer()
            Text(viewModel.slotCounterText)
                .font(.caption)
                .tracking(2)
                .foregroundStyle(StealthCeramicTheme.secondaryTextColor)
        }
    }

    // MARK: - Slot List

    private var slotListSection: some View {
        VStack(spacing: 8) {
            ForEach(viewModel.habits) { habit in
                HabitSlotRowInternal(habit: habit)
            }

            if viewModel.canAddSlot {
                addSlotButton
            }
        }
    }

    private var addSlotButton: some View {
        Button {
            // Will be wired in Phase 3
        } label: {
            Text("+ SLOT")
                .font(.caption)
                .tracking(2)
                .foregroundStyle(StealthCeramicTheme.secondaryTextColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .overlay {
                    RoundedRectangle(cornerRadius: StealthCeramicTheme.surfaceCornerRadius, style: .continuous)
                        .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [6, 4]))
                        .foregroundStyle(StealthCeramicTheme.secondaryTextColor.opacity(0.4))
                }
        }
        .buttonStyle(.plain)
    }

    // MARK: - Settings

    private var settingsDivider: some View {
        Rectangle()
            .fill(StealthCeramicTheme.secondaryTextColor.opacity(0.2))
            .frame(height: 1)
    }

    private var settingsSection: some View {
        VStack(spacing: 12) {
            settingsRow(title: "Launch at Login", isOn: $viewModel.launchAtLogin)
            settingsRow(title: "Show in Menu Bar", isOn: $viewModel.showInMenuBar)
        }
    }

    private func settingsRow(title: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(StealthCeramicTheme.primaryTextColor)
            Spacer()
            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(.blue)
        }
    }

    // MARK: - Action Bar

    private var actionBar: some View {
        HStack {
            Spacer()
            Button("CANCEL") {
                // Will be wired in Phase 4
            }
            .buttonStyle(.plain)
            .foregroundStyle(StealthCeramicTheme.secondaryTextColor)
            .tracking(2)
            .font(.caption)

            Button {
                // Will be wired in Phase 4
            } label: {
                Text("SAVE CHANGES")
                    .font(.caption)
                    .tracking(2)
                    .foregroundStyle(StealthCeramicTheme.primaryTextColor)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(StealthCeramicTheme.glassMaterial)
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(StealthCeramicTheme.glassStrokeColor, lineWidth: 1)
                    }
            }
            .buttonStyle(.plain)
        }
    }
}

// MARK: - Internal Slot Row (will be extracted in Phase 2)

private struct HabitSlotRowInternal: View {
    let habit: Habit

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: habit.iconName)
                .foregroundStyle(StealthCeramicTheme.secondaryTextColor)
                .frame(width: 24)
            Text(habit.name)
                .foregroundStyle(StealthCeramicTheme.primaryTextColor)
            Spacer()
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
    }
}

// MARK: - Schedule Description Helpers (migrated from ContentView)

extension ConfigurationViewModel {
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
            return days.map(weekdayAbbreviation).joined(separator: ", ")
        }
    }

    nonisolated static func weekdayAbbreviation(for day: HabitWeekday) -> String {
        switch day {
        case .sunday: return "Sun"
        case .monday: return "Mon"
        case .tuesday: return "Tue"
        case .wednesday: return "Wed"
        case .thursday: return "Thu"
        case .friday: return "Fri"
        case .saturday: return "Sat"
        }
    }
}

#Preview {
    ConfigurationView(
        viewModel: ConfigurationViewModel(
            habitStore: HabitStore(
                modelContext: try! ModelContext(
                    ductivaApp.makeModelContainer(inMemoryOnly: true)
                )
            )
        )
    )
}
