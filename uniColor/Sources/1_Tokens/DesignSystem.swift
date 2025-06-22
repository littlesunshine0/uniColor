import SwiftUI

/// A struct representing a complete design system. It contains collections
/// of design tokens that together define a coherent visual theme. An app can
/// support multiple `DesignSystem` instances, allowing for dynamic theming
/// (e.g., light mode, dark mode, or branded themes).
public struct DesignSystem: Identifiable {
    public var id: String { name }
    public let name: String
    
    // Dictionaries to hold the core values of the theme.
    let tokens: [TokenKey: DesignToken]
    // Font descriptions are stored instead of resolved Fonts to support Dynamic Type.
    let fonts: [TokenKey: FontDescription]

    public init(name: String, tokens: [TokenKey: DesignToken], fonts: [TokenKey: FontDescription]) {
        self.name = name
        self.tokens = tokens
        self.fonts = fonts
    }

    /// Safely retrieves a generic token for a given key.
    internal func token(for key: TokenKey) -> DesignToken? {
        tokens[key]
    }

    /// Safely retrieves a font description for a given key.
    internal func font(for key: TokenKey) -> FontDescription? {
        fonts[key]
    }
}
