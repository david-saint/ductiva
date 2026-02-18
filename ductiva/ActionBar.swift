import SwiftUI

/// Bottom action bar with Cancel and Save Changes buttons.
/// Styled to match the Stealth Ceramic design language.
struct ActionBar: View {
    var onCancel: () -> Void
    var onSave: () -> Void

    static let cancelLabel = "CANCEL"
    static let saveLabel = "SAVE CHANGES"

    var body: some View {
        HStack(spacing: 16) {
            Spacer()
            Button(Self.cancelLabel) {
                onCancel()
            }
            .buttonStyle(.plain)
            .foregroundStyle(StealthCeramicTheme.secondaryTextColor)
            .tracking(StealthCeramicTheme.counterTracking)
            .font(.system(size: 11, weight: .medium))

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
                            .fill(StealthCeramicTheme.solidButtonBackground)
                    }
            }
            .buttonStyle(.plain)
        }
    }
}
