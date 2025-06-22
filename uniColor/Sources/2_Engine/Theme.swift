import SwiftUI

/// Provides idiomatic, type-safe access to the active design system's tokens.
/// This acts as the primary, user-facing API for developers to use themed values
/// in their views. It is designed to be clean, predictable, and easy to discover.
///
/// Usage:
/// ```
/// Color.theme.primary
/// Font.theme(for: .headline)
/// CGFloat.themeSpacing.medium
/// ```
@MainActor
public enum Theme {
    internal static var manager: uniTheme { uniTheme.shared }

    /// A private helper to resolve a generic token key. This is the bridge
    /// between the static `Theme` API and the dynamic `uniTheme` manager.
    private static func token(for key: TokenKey) -> DesignToken? {
        manager.currentDesignSystem.token(for: key)
    }
    
    /// A private helper to resolve a font description key.
    internal static func fontDescription(for key: TokenKey) -> FontDescription? {
        manager.currentDesignSystem.font(for: key)
    }

    /// A proxy namespace for all color tokens.
    public enum Colors {
        public static var primary: UnifiedColor { color(named: "primary") }
        public static var accent: UnifiedColor { primary } // Alias for primary
        public static var destructive: UnifiedColor { color(named: "destructive") }
        public static var success: UnifiedColor { color(named: "success") }
        public static var warning: UnifiedColor { color(named: "warning") }
        public static var background: UnifiedColor { color(named: "background") }
        public static var backgroundSecondary: UnifiedColor { color(named: "backgroundSecondary") }
        public static var textPrimary: UnifiedColor { color(named: "textPrimary") }
        public static var textSecondary: UnifiedColor { color(named: "textSecondary") }
        public static var muted: UnifiedColor { color(named: "muted") }
        public static var border: UnifiedColor { color(named: "border") }
        
        private static func color(named name: String) -> UnifiedColor {
            let key = TokenKey(group: "color", name: name)
            guard case .staticColor(let color) = token(for: key) else {
                #if DEBUG
                fatalError("Color token '\(key)' not found or invalid.")
                #else
                return .init(hex: "#FF00FF") // Fallback for release builds
                #endif
            }
            return color
        }
    }
}
