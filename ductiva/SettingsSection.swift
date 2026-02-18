import SwiftUI

/// Inline settings rows for the Configuration window.
/// Displays "Launch at Login" and "Show in Menu Bar" toggles
/// using the Stealth Ceramic design language.
struct SettingsSection: View {
    @Binding var launchAtLogin: Bool
    @Binding var showInMenuBar: Bool

    static let launchAtLoginLabel = "Launch at Login"
    static let showInMenuBarLabel = "Show in Menu Bar"

    var body: some View {
        VStack(spacing: 12) {
            settingsRow(title: Self.launchAtLoginLabel, isOn: $launchAtLogin)
            settingsRow(title: Self.showInMenuBarLabel, isOn: $showInMenuBar)
        }
    }

    private func settingsRow(title: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 13))
                .foregroundStyle(StealthCeramicTheme.primaryTextColor)
            Spacer()
            StealthToggle(isOn: isOn)
        }
    }
}
