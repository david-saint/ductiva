import SwiftUI

/// A custom toggle styled to match the Stealth Ceramic design language.
/// Renders as a capsule track with a sliding circular knob.
struct StealthToggle: View {
    @Binding var isOn: Bool

    private let trackWidth: CGFloat = 40
    private let trackHeight: CGFloat = 22
    private let knobSize: CGFloat = 16
    private let knobPadding: CGFloat = 3

    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                isOn.toggle()
            }
        } label: {
            ZStack(alignment: isOn ? .trailing : .leading) {
                Capsule()
                    .fill(isOn ? StealthCeramicTheme.toggleActiveColor : StealthCeramicTheme.toggleInactiveColor)
                    .frame(width: trackWidth, height: trackHeight)

                Circle()
                    .fill(isOn ? Color.black : StealthCeramicTheme.toggleKnobColor)
                    .frame(width: knobSize, height: knobSize)
                    .padding(.horizontal, knobPadding)
            }
        }
        .buttonStyle(.plain)
    }
}
