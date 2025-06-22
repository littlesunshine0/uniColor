//
//  FontProvider.swift
//  uniColor
//
//  Created by garyrobertellis on 6/21/25.
//


import SwiftUI

/// A central engine for resolving font descriptions into concrete, dynamic `Font` objects.
/// This provider is the key to supporting Dynamic Type and other accessibility features.
/// It decouples the abstract request for a font (the `FontDescription`) from the
/// final, rendered `Font` object.
@MainActor
public enum FontProvider {
    
    // By using the @Environment property wrapper, we ensure that our font resolver
    // always has access to the user's current text size preferences.
    @Environment(\.sizeCategory) private static var sizeCategory

    /// Resolves a font description into a `Font` that respects Dynamic Type.
    public static func font(for description: FontDescription?) -> Font {
        guard let description else { return .body }
        
        // Use SwiftUI's dynamic font scaling capabilities by starting with a base system font.
        var baseFont = Font.system(size: description.size, weight: description.weight.swiftUIWeight)
        
        // Apply italicization if requested.
        if description.isItalic {
            baseFont = baseFont.italic()
        }
        
        // Apply family-specific design characteristics.
        switch description.family {
        case .sjElite:
            return baseFont.monospacedDigit().leading(.tight)
        case .sjMini:
            return baseFont.leading(.standard)
        case .uniSJ:
            return Font.system(.body, design: .monospaced)
        }
    }
    
    /// A convenience method to resolve a semantic font style (e.g., `.headline`).
    public static func font(for style: Font.TextStyle) -> Font {
        guard let description = Theme.fontDescription(for: style.tokenKey) else {
            return .system(style)
        }
        return font(for: description)
    }

    /// A convenience method to resolve a font from a token key.
    public static func font(for key: TokenKey) -> Font {
        guard let description = Theme.fontDescription(for: key) else {
            return .body
        }
        return font(for: description)
    }
}
