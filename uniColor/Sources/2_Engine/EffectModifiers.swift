import SwiftUI

/// Applies a standard, theme-aware shadow effect. This modifier encapsulates
/// the specific `shadow()` parameters into a reusable form.
public struct ShadowEffect: ViewModifier {
    let color: Color
    let radius: CGFloat
    let y: CGFloat
    
    public func body(content: Content) -> some View {
        content.shadow(color: color, radius: radius, y: y)
    }
}

/// Applies a soft, glowing aura effect, often used for focus or emphasis.
/// The effect is achieved by layering multiple soft shadows.
public struct GlowEffect: ViewModifier {
    let color: Color
    let radius: CGFloat

    public func body(content: Content) -> some View {
        content
            .shadow(color: color, radius: radius / 2, y: 0)
            .shadow(color: color, radius: radius, y: 0)
    }
}

/// Applies a translucent, frosted-glass material background. This modifier
/// gracefully handles OS availability for the `.ultraThinMaterial`.
public struct GlassEffect: ViewModifier {
    public func body(content: Content) -> some View {
        if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
            content.background(.ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: .themeRadius.card, style: .continuous)
            )
        } else {
            // Fallback for older OS versions provides a similar translucent feel.
            content.background(
                Color.theme.backgroundSecondary.swiftUIColor.opacity(0.85)
            )
        }
    }
}
