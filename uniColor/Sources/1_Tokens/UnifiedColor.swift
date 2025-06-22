import SwiftUI

/// A platform-agnostic, immutable struct representing a color in the sRGB space.
/// It is the foundation of the entire color system, decoupling the abstract concept
/// of a color from its platform-specific implementation (e.g., `UIColor`).
public struct UnifiedColor: Hashable {
    public let red: Double
    public let green: Double
    public let blue: Double
    public let alpha: Double

    public init(red: Double, green: Double, blue: Double, alpha: Double = 1.0) {
        self.red = max(0.0, min(1.0, red))
        self.green = max(0.0, min(1.0, green))
        self.blue = max(0.0, min(1.0, blue))
        self.alpha = max(0.0, min(1.0, alpha))
    }
    
    public static var white: UnifiedColor { .init(red: 1, green: 1, blue: 1) }
    
    /// A computed property to easily convert to a SwiftUI Color for rendering.
    public var swiftUIColor: Color {
        Color(red: red, green: green, blue: blue, opacity: alpha)
    }

    /// Returns a new instance of the color with a modified alpha component.
    public func withOpacity(_ newAlpha: Double) -> UnifiedColor {
        UnifiedColor(red: self.red, green: self.green, blue: self.blue, alpha: newAlpha)
    }
}
