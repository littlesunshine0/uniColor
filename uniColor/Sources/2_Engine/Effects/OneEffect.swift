import SwiftUI

/// A declarative API for applying a suite of reusable visual effects. This View
/// extension provides a single, clean entry point (`.oneEffect()`) for adding
/// shadows, glows, and materials, keeping the view code readable.
public extension View {
    @ViewBuilder
    func oneEffect(_ effect: OneEffect?) -> some View {
        switch effect {
        case .shadow(let color, let radius, let y):
            self.modifier(ShadowEffect(color: color, radius: radius, y: y))
        case .glow(let color, let radius):
            self.modifier(GlowEffect(color: color, radius: radius))
        case .glass:
            self.modifier(GlassEffect())
        case .none:
            self
        }
    }
}

/// An enumeration of available visual effects that can be applied to a View.
/// By defining effects as enum cases, we can easily add new ones in the future
/// without breaking existing view code.
public enum OneEffect {
    case shadow(color: Color, radius: CGFloat, y: CGFloat)
    case glow(color: Color, radius: CGFloat)
    case glass
}
