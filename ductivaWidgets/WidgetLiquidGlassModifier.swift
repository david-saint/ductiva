import SwiftUI
import WidgetKit

struct WidgetLiquidGlassModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .containerBackground(for: .widget) {
                // Stealth Ceramic base: near-black with a subtle hint of translucency.
                // We layer a thin material BEHIND an opaque-enough color so the widget
                // content isn't washed out by vibrancy, while still picking up a faint
                // desktop tint at the edges for a "liquid glass" feel.
                ZStack {
                    Color(red: 0.11, green: 0.11, blue: 0.12)
                }
            }
    }
}

extension View {
    func widgetLiquidGlassBackground() -> some View {
        modifier(WidgetLiquidGlassModifier())
    }
}
