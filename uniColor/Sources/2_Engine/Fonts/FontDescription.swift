//
//  acts.swift
//  uniColor
//
//  Created by garyrobertellis on 6/21/25.
//


import SwiftUI

/// A serializable, theme-agnostic description of a font. This struct acts
/// as the token value before it is resolved into a `Font` by the `FontProvider`.
/// It is `Hashable`, allowing it to be used in collections.
public struct FontDescription: Hashable {
    let family: SJFamily
    let size: CGFloat
    let weight: SJWeight
    var isItalic: Bool = false
}

/// Enum representing the custom font families in the design system. Each family
/// is designed for a specific context or platform.
public enum SJFamily: Hashable {
    /// The primary, versatile font family for general UI text.
    case sjElite
    /// A variant optimized for smaller sizes and legibility, like on watchOS.
    case sjMini
    /// A  variant for coding environments or tabular data.
    case uniSJ
}

/// Represents the full range of ten font weights for the SJ Elite family,
/// giving designers fine-grained control over typography.
public enum SJWeight: Hashable {
    case thin, extraLight, light, regular, medium, semiBold, bold, extraBold, black, heavy
    
    /// Maps a custom weight to the closest available `Font.Weight` in SwiftUI.
    var swiftUIWeight: Font.Weight {
        switch self {
        case .thin: return .thin
        case .extraLight: return .ultraLight
        case .light: return .light
        case .regular: return .regular
        case .medium: return .medium
        case .semiBold: return .semibold
        case .bold: return .bold
        case .extraBold: return .heavy
        case .black: return .black
        case .heavy: return .heavy
        }
    }
}
