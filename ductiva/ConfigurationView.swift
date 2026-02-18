import SwiftUI
import SwiftData

struct ConfigurationView: View {
    @State var viewModel: ConfigurationViewModel
    @State private var selectedHabit: Habit?
    @State private var showAddSlotSheet = false

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()

            Rectangle()
                .fill(StealthCeramicTheme.chassisColor.opacity(0.55))
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                headerSection
                Spacer().frame(height: 20)
                slotListSection
                Spacer().frame(height: 20)
                settingsDivider
                Spacer().frame(height: 16)
                settingsSection
                Spacer()
                actionBar
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 20)
        }
        .sheet(item: $selectedHabit) { habit in
            HabitStreakPlaceholderView(habit: habit)
                .frame(minWidth: 360, minHeight: 400)
        }
        .sheet(isPresented: $showAddSlotSheet) {
            AddSlotSheet { name, iconName, schedule in
                viewModel.addHabit(name: name, iconName: iconName, schedule: schedule)
            }
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
                .tracking(StealthCeramicTheme.headerTracking)
                .foregroundStyle(StealthCeramicTheme.primaryTextColor)
            Spacer()
            Text(viewModel.slotCounterText)
                .font(.caption)
                .tracking(StealthCeramicTheme.counterTracking)
                .foregroundStyle(StealthCeramicTheme.secondaryTextColor)
        }
    }

    // MARK: - Slot List

    private var slotListSection: some View {
        VStack(spacing: 8) {
            ForEach(viewModel.habits) { habit in
                Button {
                    selectedHabit = habit
                } label: {
                    HabitSlotRow(habit: habit, onDelete: {
                        viewModel.removeHabit(habit)
                    })
                }
                .buttonStyle(.plain)
            }

            if viewModel.canAddSlot {
                AddSlotButton {
                    showAddSlotSheet = true
                }
                .padding(.top, 8)
            }
        }
    }

    // MARK: - Settings

    private var settingsDivider: some View {
        Rectangle()
            .fill(StealthCeramicTheme.dividerColor)
            .frame(height: 1)
    }

    private var settingsSection: some View {
        SettingsSection(
            launchAtLogin: $viewModel.launchAtLogin,
            showInMenuBar: $viewModel.showInMenuBar
        )
    }

    // MARK: - Action Bar

    private var actionBar: some View {
        ActionBar(
            onCancel: { viewModel.discardChanges() },
            onSave: { viewModel.saveChanges() }
        )
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
    let container = try! ductivaApp.makeModelContainer(inMemoryOnly: true)
    let context = ModelContext(container)
    let store = HabitStore(modelContext: context)

    // Seed preview data
    _ = try! store.createHabit(name: "Deep Work", iconName: "display", schedule: .daily)
    _ = try! store.createHabit(name: "Strength Training", iconName: "dumbbell", schedule: .daily)
    _ = try! store.createHabit(name: "Side Project", iconName: "chevron.left.forwardslash.chevron.right", schedule: .weekly)

    let viewModel = ConfigurationViewModel(habitStore: store)
    viewModel.loadHabits()

    return ConfigurationView(viewModel: viewModel)
}
