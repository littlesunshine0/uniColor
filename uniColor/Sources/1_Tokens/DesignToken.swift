import SwiftUI

/// A type-erased container for any fundamental design system value. By using
/// an enum, we can store different types of tokens (colors, spacing, etc.) in
/// a single dictionary within the `DesignSystem` struct, while maintaining
/// type safety at the point of use.
public enum DesignToken: Hashable {
    /// A static, absolute color value.
    case staticColor(UnifiedColor)
    /// A unit of space, typically in points.
    case spacing(CGFloat)
    /// A corner radius value.
    case radius(CGFloat)
    /// A duration for animations, in seconds.
    case timeInterval(TimeInterval)
    /// A named asset from the bundle's asset catalog (e.g., an image).
    case asset(String)
}
