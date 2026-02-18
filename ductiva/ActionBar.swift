import SwiftUI

/// Bottom action bar with Cancel and Save Changes buttons.
/// Styled to match the Stealth Ceramic design language.
/// Both buttons are disabled when `isDisabled` is true (no unsaved changes).
struct ActionBar: View {
    var onCancel: () -> Void
    var onSave: () -> Void
    var isDisabled: Bool = false

    static let cancelLabel = "CANCEL"
    static let saveLabel = "SAVE CHANGES"

    var body: some View {
        HStack(spacing: 16) {
            Spacer()
            Button(Self.cancelLabel) {
                onCancel()
            }
            .buttonStyle(.plain)
            .foregroundStyle(StealthCeramicTheme.secondaryTextColor.opacity(isDisabled ? 0.35 : 1.0))
            .tracking(StealthCeramicTheme.counterTracking)
            .font(.system(size: 11, weight: .medium))
            .disabled(isDisabled)

            Button {
                onSave()
            } label: {
                Text(Self.saveLabel)
                    .font(.system(size: 11, weight: .semibold))
                    .tracking(StealthCeramicTheme.counterTracking)
                    .foregroundStyle(StealthCeramicTheme.solidButtonForeground)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 9)
                    .background {
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .fill(StealthCeramicTheme.solidButtonBackground.opacity(isDisabled ? 0.3 : 1.0))
                    }
            }
            .buttonStyle(.plain)
            .disabled(isDisabled)
        }
        .animation(.easeInOut(duration: 0.2), value: isDisabled)
    }
}
