import SwiftUI

/// A single habit row displaying the icon and name.
/// Flat by default; glass material appears on hover for interactive feedback.
/// Supports an optional right-click context menu for deletion.
struct HabitSlotRow: View {
    let habit: Habit
    var isCompletedToday: Bool = false
    var onToggleCompletion: (() -> Void)?

    /// Optional callback invoked when "Delete" is selected from the context menu.
    var onDelete: (() -> Void)?

    @State private var isHovered = false

    var body: some View {
        rowContent
            .background {
                RoundedRectangle(cornerRadius: StealthCeramicTheme.surfaceCornerRadius, style: .continuous)
                    .fill(isHovered ? StealthCeramicTheme.surfaceHoverColor : StealthCeramicTheme.surfaceColor)
            }
            .animation(.easeInOut(duration: 0.2), value: isHovered)
            .onHover { hovering in
                isHovered = hovering
            }
            .contextMenu {
                if let onToggleCompletion {
                    Button {
                        onToggleCompletion()
                    } label: {
                        Label(
                            isCompletedToday ? "Mark Incomplete Today" : "Mark Completed Today",
                            systemImage: isCompletedToday ? "xmark.circle" : "checkmark.circle"
                        )
                    }
                }

                if let onDelete {
                    Button(role: .destructive) {
                        onDelete()
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
    }

    private var rowContent: some View {
        HStack(spacing: 14) {
            Image(systemName: habit.iconName)
                .font(.system(size: 16))
                .foregroundStyle(StealthCeramicTheme.secondaryTextColor)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 1) {
                Text(habit.name)
                    .font(.system(size: 13))
                    .foregroundStyle(StealthCeramicTheme.primaryTextColor)
                Text(habit.schedule.localizedDescription)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(StealthCeramicTheme.secondaryTextColor.opacity(0.8))
            }
            Spacer()
            Image(systemName: isCompletedToday ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(
                    isCompletedToday
                        ? Color(red: 0.95, green: 0.99, blue: 1.0)
                        : StealthCeramicTheme.secondaryTextColor.opacity(0.55)
                )
        }
        .padding(.vertical, 11)
        .padding(.horizontal, 14)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(habit.name), \(isCompletedToday ? "completed today" : "not completed today")")
        .accessibilityHint("Select to view streak details. Use context menu to toggle completion.")
    }
}
