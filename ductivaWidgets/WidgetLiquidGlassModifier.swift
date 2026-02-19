import SwiftUI
import WidgetKit

struct WidgetLiquidGlassModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .containerBackground(for: .widget) {
                // We use standard widget backgrounds to integrate nicely with macOS.
                // Stealth Ceramic base color but translucent
                Color(red: 0.11, green: 0.11, blue: 0.12).opacity(0.8)
                    .background(.regularMaterial)
            }
    }
}

extension View {
    func widgetLiquidGlassBackground() -> some View {
        modifier(WidgetLiquidGlassModifier())
    }
}