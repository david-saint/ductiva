import SwiftUI
import SwiftData

struct ConfigurationView: View {
    private struct AddSlotSheetToken: Identifiable {
        let id = UUID()
    }

    @State var viewModel: ConfigurationViewModel
    @State private var selectedHabit: Habit?
    @State private var addSlotSheetToken: AddSlotSheetToken?
    @State private var pendingDeepLinkHabitID: UUID?

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
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.caption2)
                        .foregroundStyle(.red.opacity(0.85))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 8)
                }
                actionBar
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 20)
        }
        .sheet(item: $selectedHabit) { habit in
            HabitStreakDetailView(habit: habit)
                .frame(minWidth: 360, minHeight: 400)
        }
        .sheet(item: $addSlotSheetToken) { _ in
            AddSlotSheet { name, iconName, schedule in
                withAnimation(.easeInOut(duration: 0.25)) {
                    viewModel.addHabit(name: name, iconName: iconName, schedule: schedule)
                }
            }
        }
        .onAppear {
            viewModel.loadHabits()
            resolvePendingDeepLink()
        }
        .onOpenURL { url in
            guard let route = HabitAppRoute(url: url) else { return }
            switch route {
            case .habitDetail(let id):
                pendingDeepLinkHabitID = id
                if viewModel.habits.isEmpty {
                    viewModel.loadHabits()
                }
                resolvePendingDeepLink()
            }
        }
        .onChange(of: viewModel.habits.map(\.id)) { _, _ in
            resolvePendingDeepLink()
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
                    HabitSlotRow(
                        habit: habit,
                        isCompletedToday: viewModel.isCompletedToday(for: habit),
                        onToggleCompletion: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                viewModel.toggleCompletionToday(for: habit)
                            }
                        },
                        onDelete: {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                viewModel.removeHabit(habit)
                            }
                        }
                    )
                }
                .buttonStyle(.plain)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }

            if viewModel.canAddSlot {
                AddSlotButton {
                    addSlotSheetToken = AddSlotSheetToken()
                }
                .padding(.top, 8)
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: viewModel.habits.count)
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
            onSave: { viewModel.saveChanges() },
            isDisabled: !viewModel.hasUnsavedChanges
        )
    }

    private func resolvePendingDeepLink() {
        guard let pendingDeepLinkHabitID else { return }
        guard let habit = viewModel.habit(withID: pendingDeepLinkHabitID) else { return }

        selectedHabit = habit
        self.pendingDeepLinkHabitID = nil
    }
}

#Preview {
    struct PreviewWrapper: View {
        var body: some View {
            if let container = try? SharedContainer.makeInMemory() {
                let store = Self.makeSeededStore(container: container)
                let viewModel = ConfigurationViewModel(habitStore: store)
                ConfigurationView(viewModel: viewModel)
                    .onAppear { viewModel.loadHabits() }
            } else {
                Text("Preview unavailable")
                    .padding()
            }
        }

        private static func makeSeededStore(container: ModelContainer) -> HabitStore {
            let context = ModelContext(container)
            let store = HabitStore(modelContext: context)
            _ = try? store.createHabit(name: "Deep Work", iconName: "display", schedule: .daily)
            _ = try? store.createHabit(name: "Strength Training", iconName: "dumbbell", schedule: .daily)
            _ = try? store.createHabit(name: "Side Project", iconName: "chevron.left.forwardslash.chevron.right", schedule: .weekly)
            return store
        }
    }
    return PreviewWrapper()
}
