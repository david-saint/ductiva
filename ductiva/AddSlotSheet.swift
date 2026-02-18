import SwiftUI

/// A modal sheet for adding a new habit slot.
/// Presents a form with name field, icon picker grid, and schedule picker.
struct AddSlotSheet: View {
    /// The available SF Symbol icon options for habit slots.
    static let iconOptions: [String] = [
        "display",
        "dumbbell",
        "chevron.left.forwardslash.chevron.right",
        "book",
        "brain.head.profile",
        "heart",
        "target",
        "pencil",
    ]

    /// The name entered by the user.
    @State var name: String = ""

    /// The currently selected SF Symbol icon name.
    @State var selectedIcon: String = "target"

    /// The selected schedule type.
    @State var selectedScheduleType: ScheduleType = .daily

    /// The selected specific days (only used when `selectedScheduleType == .specificDays`).
    @State var selectedDays: Set<HabitWeekday> = []

    /// Callback when the user saves.
    /// Parameters: name, iconName, schedule.
    var onSave: (String, String, HabitSchedule) -> Void

    @Environment(\.dismiss) private var dismiss

    /// Validates whether a habit name is acceptable (non-empty, non-whitespace).
    static func validateName(_ name: String) -> Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    /// Toggles a weekday in/out of a selection set.
    static func toggleDay(_ day: HabitWeekday, in days: inout Set<HabitWeekday>) {
        if days.contains(day) {
            days.remove(day)
        } else {
            days.insert(day)
        }
    }

    /// Whether the current form input is valid for saving.
    var isValid: Bool {
        Self.validateName(name)
    }

    var body: some View {
        ZStack {
            StealthCeramicTheme.chassisColor.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 20) {
                headerSection
                nameField
                iconPickerSection
                scheduleSection
                Spacer()
                actionBar
            }
            .padding(24)
        }
        .frame(minWidth: 360, minHeight: 420)
    }

    // MARK: - Header

    private var headerSection: some View {
        Text("NEW SLOT")
            .font(.title3.bold())
            .tracking(StealthCeramicTheme.headerTracking)
            .foregroundStyle(StealthCeramicTheme.primaryTextColor)
    }

    // MARK: - Name Field

    private var nameField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("NAME")
                .font(.caption)
                .tracking(StealthCeramicTheme.counterTracking)
                .foregroundStyle(StealthCeramicTheme.secondaryTextColor)

            TextField("e.g. Deep Work", text: $name)
                .textFieldStyle(.plain)
                .font(.system(size: 13))
                .foregroundStyle(StealthCeramicTheme.primaryTextColor)
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .background {
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(StealthCeramicTheme.surfaceColor)
                }
        }
    }

    // MARK: - Icon Picker

    private var iconPickerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("ICON")
                .font(.caption)
                .tracking(StealthCeramicTheme.counterTracking)
                .foregroundStyle(StealthCeramicTheme.secondaryTextColor)

            LazyVGrid(columns: Array(repeating: GridItem(.fixed(44), spacing: 8), count: 4), spacing: 8) {
                ForEach(Self.iconOptions, id: \.self) { icon in
                    Button {
                        selectedIcon = icon
                    } label: {
                        Image(systemName: icon)
                            .font(.system(size: 18))
                            .foregroundStyle(
                                selectedIcon == icon
                                    ? StealthCeramicTheme.primaryTextColor
                                    : StealthCeramicTheme.secondaryTextColor
                            )
                            .frame(width: 44, height: 44)
                            .background {
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(
                                        selectedIcon == icon
                                            ? StealthCeramicTheme.surfaceHoverColor
                                            : StealthCeramicTheme.surfaceColor
                                    )
                            }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - Schedule

    private var scheduleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("SCHEDULE")
                .font(.caption)
                .tracking(StealthCeramicTheme.counterTracking)
                .foregroundStyle(StealthCeramicTheme.secondaryTextColor)

            Picker("Schedule", selection: $selectedScheduleType) {
                ForEach(ScheduleType.allCases, id: \.self) { type in
                    Text(type.label).tag(type)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()

            if selectedScheduleType == .specificDays {
                dayToggleButtons
            }
        }
    }

    /// Abbreviation labels for each weekday in display order (Sun–Sat).
    private static let weekdayLabels: [(day: HabitWeekday, label: String)] = [
        (.sunday, "S"), (.monday, "M"), (.tuesday, "T"),
        (.wednesday, "W"), (.thursday, "T"), (.friday, "F"), (.saturday, "S"),
    ]

    private var dayToggleButtons: some View {
        HStack(spacing: 6) {
            ForEach(Self.weekdayLabels, id: \.day) { item in
                let isSelected = selectedDays.contains(item.day)
                Button {
                    Self.toggleDay(item.day, in: &selectedDays)
                } label: {
                    Text(item.label)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(
                            isSelected
                                ? StealthCeramicTheme.primaryTextColor
                                : StealthCeramicTheme.secondaryTextColor
                        )
                        .frame(width: 32, height: 32)
                        .background {
                            Circle()
                                .fill(
                                    isSelected
                                        ? StealthCeramicTheme.surfaceHoverColor
                                        : StealthCeramicTheme.surfaceColor
                                )
                        }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.top, 4)
    }

    // MARK: - Action Bar

    private var actionBar: some View {
        HStack(spacing: 16) {
            Spacer()
            Button("CANCEL") {
                dismiss()
            }
            .buttonStyle(.plain)
            .foregroundStyle(StealthCeramicTheme.secondaryTextColor)
            .tracking(StealthCeramicTheme.counterTracking)
            .font(.system(size: 11, weight: .medium))

            Button {
                guard isValid else { return }
                let schedule = selectedScheduleType.toHabitSchedule(
                    selectedDays: Array(selectedDays).sorted { $0.rawValue < $1.rawValue }
                )
                onSave(name.trimmingCharacters(in: .whitespaces), selectedIcon, schedule)
                dismiss()
            } label: {
                Text("ADD SLOT")
                    .font(.system(size: 11, weight: .semibold))
                    .tracking(StealthCeramicTheme.counterTracking)
                    .foregroundStyle(StealthCeramicTheme.solidButtonForeground)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 9)
                    .background {
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .fill(
                                isValid
                                    ? StealthCeramicTheme.solidButtonBackground
                                    : StealthCeramicTheme.solidButtonBackground.opacity(0.4)
                            )
                    }
            }
            .buttonStyle(.plain)
            .disabled(!isValid)
        }
    }
}

// MARK: - Schedule Type

/// Represents the schedule picker options in the AddSlotSheet.
enum ScheduleType: String, CaseIterable {
    case daily
    case weekly
    case specificDays

    var label: String {
        switch self {
        case .daily: return "Daily"
        case .weekly: return "Weekly"
        case .specificDays: return "Specific Days"
        }
    }

    /// Converts to a `HabitSchedule`. For `.specificDays`, defaults to empty array
    /// (day selection is handled separately in Task 3.2).
    func toHabitSchedule(selectedDays: [HabitWeekday] = []) -> HabitSchedule {
        switch self {
        case .daily: return .daily
        case .weekly: return .weekly
        case .specificDays: return .specificDays(selectedDays)
        }
    }
}
