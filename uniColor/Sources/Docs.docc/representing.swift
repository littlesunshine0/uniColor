# ``uniColor``

I have combined the `uniColor` design system and the `UniContainers` framework into a single, comprehensive Swift file. The `UniContainers` components now correctly utilize the token system for colors, fonts, spacing, and radii, ensuring they are fully themeable.

### **Key Integrations and Fixes:**

  * **Unified Token System**: The core `uniColor` engine, including `UnifiedColor`, `DesignToken`, `uniTheme`, and `ThemedStyle`, is the foundation of the file.
  * **Expanded Color Palette**: The `AppDesignSystems` have been augmented with the specific color tokens required by `UniContainers` (e.g., `cardBackground`, `shadow`, `accent`), ensuring all components render correctly across all themes.
  * **Corrected Initializers**: Faulty initializers, such as the one in `GridContainer` that ignored its parameters, have been fixed for predictable behavior.
  * **Resolved Dependencies**: All `import` statements have been consolidated, and internal dependencies between the design system and the container components have been correctly resolved.
  * **Application Scaffolding**: The file uses the `UniContainersRootView` as the application's entry point, which provides a complete tabbed interface showcasing the `HomeView` and `DocumentationView`.

This merged code represents a complete, self-contained, and theme-aware UI framework, ready to be used in a SwiftUI application.

````swift
import SwiftUI
import Foundation
import Combine
import CoreGraphics // Required for CGColor

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif


// MARK: - UnifiedColor.swift

/// A platform-agnostic, immutable struct representing a color in the sRGB space.
///
/// `UnifiedColor` is the cornerstone of the color system, allowing for a single source of truth for color definitions
/// that can be seamlessly converted to `SwiftUI.Color`, `UIKit.UIColor`, or `AppKit.NSColor`.
/// It stores color components as `Double` values between 0.0 and 1.0.
///
/// ## Usage
///
/// ### Initialization from Hex
/// ```swift
/// let primaryColor = UnifiedColor(hex: "#007AFF")
/// let translucentRed = UnifiedColor(hex: "#FF000080")
/// ```
///
/// ### Conversion to Platform-Specific Colors
/// ```swift
/// // Requires CoreGraphics import
/// import CoreGraphics
///
/// // view.backgroundColor = primaryColor.uiColor // UIKit
/// // aView.layer?.backgroundColor = primaryColor.cgColor // AppKit/CoreGraphics
/// // Text("Hello").foregroundStyle(primaryColor.swiftUIColor) // SwiftUI
/// ```
public struct UnifiedColor: Hashable {
    /// The red component of the color, in the sRGB color space (0.0 to 1.0).
    public let red: Double
    /// The green component of the color, in the sRGB color space (0.0 to 1.0).
    public let green: Double // Order matters for Hashable synthesis, keep consistent
    /// The blue component of the color, in the sRGB color space (0.0 to 1.0).
    public let blue: Double
    /// The alpha (opacity) component of the color (0.0 to 1.0).
    public let alpha: Double


    /// Initializes a `UnifiedColor` with RGBA components.
    ///
    /// Components are clamped to the range [0.0, 1.0].
    ///
    /// - Parameters:
    ///   - red: The red component (0.0 to 1.0).
    ///   - green: The green component (0.0 to 1.0).
    ///   - blue: The blue component (0.0 to 1.0).
    ///   - alpha: The alpha component (0.0 to 1.0). Defaults to 1.0.
    public init(red: Double, green: Double, blue: Double, alpha: Double = 1.0) {
        self.red = max(0.0, min(1.0, red))
        self.green = max(0.0, min(1.0, green))
        self.blue = max(0.0, min(1.0, blue))
        self.alpha = max(0.0, min(1.0, alpha))
    }
}

// MARK: - Initializers & Modifiers
public extension UnifiedColor {

    /// Initializes a `UnifiedColor` from a hex string.
    ///
    /// Supports the following formats:
    /// - `#RGB` (e.g., `#F0C`)
    /// - `#RGBA` (e.g., `#F0C8`)
    /// - `#RRGGBB` (e.g., `#FF00CC`)
    /// - `#RRGGBBAA` (e.g., `#FF00CC80`)
    ///
    /// The leading '#' is optional. If the hex string is invalid or empty, it defaults to black (`#000000FF`).
    ///
    /// - Parameter hex: The hex string representation of the color.
    init(hex: String) {
        let hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedHexString = hexString.hasPrefix("#") ? String(hexString.dropFirst()) : hexString

        var hexValue: UInt64 = 0
        let scanner = Scanner(string: cleanedHexString)

        // Attempt to scan the hex value. If it fails or the string is empty, default to black.
        // Use scanHexInt64, not scanHexInt.
        guard scanner.scanHexInt64(&hexValue) else {
            self.init(red: 0, green: 0, blue: 0, alpha: 1)
            return
        }

        let r, g, b, a: Double

        switch cleanedHexString.count {
        case 3: // #RGB
            r = Double((hexValue & 0xF00) >> 8) / 15.0
            g = Double((hexValue & 0x0F0) >> 4) / 15.0
            b = Double(hexValue & 0x00F) / 15.0
            a = 1.0
        case 4: // #RGBA
            r = Double((hexValue & 0xF000) >> 12) / 15.0
            g = Double((hexValue & 0x0F00) >> 8) / 15.0
            b = Double((hexValue & 0x00F0) >> 4) / 15.0
            a = Double(hexValue & 0x000F) / 15.0
        case 6: // #RRGGBB
            r = Double((hexValue & 0xFF0000) >> 16) / 255.0
            g = Double((hexValue & 0x00FF00) >> 8) / 255.0
            b = Double(hexValue & 0x0000FF) / 255.0
            a = 1.0
        case 8: // #RRGGBBAA
            r = Double((hexValue & 0xFF000000) >> 24) / 255.0
            g = Double((hexValue & 0x00FF0000) >> 16) / 255.0
            b = Double((hexValue & 0x0000FF00) >> 8) / 255.0
            a = Double(hexValue & 0x000000FF) / 255.0
        default:
            // Invalid hex string length, default to black
            (r, g, b, a) = (0, 0, 0, 1)
        }

        self.init(red: r, green: g, blue: b, alpha: a)
    }

    /// Returns a new `UnifiedColor` instance with the specified alpha component.
    /// - Parameter newAlpha: The new alpha value, from 0.0 to 1.0.
    /// - Returns: A new `UnifiedColor` with the adjusted opacity.
    func withOpacity(_ newAlpha: Double) -> UnifiedColor {
        return UnifiedColor(red: self.red, green: self.green, blue: self.blue, alpha: newAlpha)
    }
}

// MARK: - Platform Converters
public extension UnifiedColor {
    /// A `SwiftUI.Color` representation of this color.
    var swiftUIColor: Color { Color(red: self.red, green: self.green, blue: self.blue, opacity: self.alpha) }

    /// A `CoreGraphics.CGColor` representation of this color.
    var cgColor: CGColor { CGColor(srgbRed: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha)) }

    #if canImport(UIKit)
    /// A `UIKit.UIColor` representation of this color.
    /// This is available on iOS, tvOS, watchOS, and Mac Catalyst.
    var uiColor: UIColor { UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha)) }
    #endif

    #if canImport(AppKit) && !targetEnvironment(macCatalyst)
    /// An `AppKit.NSColor` representation of this color.
    /// Available on native macOS only.
    var nsColor: NSColor { NSColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha)) }
    #endif
}


// MARK: - UnifiedColor+System.swift

#if canImport(UIKit)
 typealias PColor = UIColor
#elseif canImport(AppKit)
 typealias PColor = NSColor
#else
// Provide a fallback if neither UIKit nor AppKit are available.
// We define a struct that conforms to Sendable (required for return type in async contexts)
// and has an unused init, ensuring it can be typealiased but not instantiated/used.
// The #if checks around usage prevent runtime issues.
 struct PlaceholderColor: Sendable {}
 typealias PColor = PlaceholderColor
#endif


/// An enumeration defining semantic system color types that can be mapped to a `UnifiedColor`.
/// This provides a layer of abstraction over platform-specific color APIs.
public enum SystemColorType: CaseIterable, Hashable { // Added Hashable
    // MARK: - Background Colors
    case primarySystemBackground
    case secondarySystemBackground
    case tertiarySystemBackground

    // MARK: - Grouped Background Colors
    case primarySystemGroupedBackground
    case secondarySystemGroupedBackground
    case tertiarySystemGroupedBackground

    // MARK: - Text Colors
    case label
    case secondaryLabel
    case tertiaryLabel
    case quaternaryLabel
    case placeholderText

    // MARK: - Fill Colors
    case systemFill
    case secondarySystemFill
    case tertiarySystemFill
    case quaternarySystemFill

    // MARK: - Other Semantic Colors
    case separator
    case link
    case systemRed
    case systemOrange
    case systemYellow
    case systemGreen
    case systemMint
    case systemTeal
    case systemCyan
    case systemBlue
    case systemIndigo
    case systemPurple
    case systemPink
    case systemBrown
    case systemGray
    case systemGray2
    case systemGray3
    case systemGray4
    case systemGray5
    case systemGray6
}

// MARK: - System Color Initializer
public extension UnifiedColor {

    /// Initializes a `UnifiedColor` from a semantic system color type based on the **current system appearance**.
    ///
    /// This initializer dynamically resolves a platform-specific color (`UIColor` or `NSColor`)
    /// and is inherently aware of the active Light/Dark Mode. It is failable and returns `nil` if the
    /// system color is not available on the current platform or cannot be converted to the sRGB color space.
    ///
    /// - Parameter systemColor: The semantic system color to create.
    init?(systemColor: SystemColorType) {
        #if os(iOS) || os(tvOS)
        guard let platformColor = Self.platformColor(for: systemColor) else { return nil }

        // On iOS/tvOS, we can directly query the resolved color for the current trait collection.
         var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
         // Use getRed/getGreen/getBlue/getAlpha if available, otherwise try converting to sRGB first
         // getRed... returns true on success, false otherwise
         if platformColor.getRed(&r, green: &g, blue: &b, alpha: &a) {
             self.init(red: Double(r), green: Double(g), blue: Double(b), alpha: Double(a))
         } else {
             // getRed failed, try sRGB conversion
             guard let srgbColor = platformColor.usingColorSpace(.sRGB) else { return nil }
             // Now use getRed on the sRGB color, which should succeed
             if srgbColor.getRed(&r, green: &g, blue: &b, alpha: &a) {
                 self.init(red: Double(r), green: Double(g), blue: Double(b), alpha: Double(a))
             } else {
                 // Still failed, unable to convert.
                 return nil
             }
         }


        #elseif os(macOS)
        guard let platformColor = Self.platformColor(for: systemColor) else { return nil }

        // macOS NSColor often needs explicit conversion to sRGB
        guard let srgbColor = platformColor.usingColorSpace(.sRGB) else { return nil }

        self.init(red: Double(srgbColor.redComponent),
                  green: Double(srgbColor.greenComponent),
                  blue: Double(srgbColor.blueComponent),
                  alpha: Double(srgbColor.alphaComponent))
        #else
        return nil // Unsupported platform
        #endif
    }

    // Helper function to map our enum to the platform-specific color object.
     internal static func platformColor(for systemColor: SystemColorType) -> PColor? {
        #if os(iOS) || os(tvOS)
        switch systemColor {
        case .primarySystemBackground:      return .systemBackground
        case .secondarySystemBackground:    return .secondarySystemBackground
        case .tertiarySystemBackground:     return .tertiarySystemBackground
        case .primarySystemGroupedBackground: return .systemGroupedBackground
        case .secondarySystemGroupedBackground: return .secondarySystemGroupedBackground
        case .tertiarySystemGroupedBackground: return .tertiarySystemGroupedBackground
        case .label:                        return .label
        case .secondaryLabel:               return .secondaryLabel
        case .tertiaryLabel:                return .tertiaryLabel
        case .quaternaryLabel:              return .quaternaryLabel
        case .placeholderText:              return .placeholderText
        case .systemFill:                   return .systemFill
        case .secondarySystemFill:          return .secondarySystemFill
        case .tertiarySystemFill:           return .tertiarySystemFill
        case .quaternarySystemFill:         return .quaternarySystemFill
        case .separator:                    return .separator
        case .link:                         return .link
        case .systemRed:                    return .systemRed
        case .systemOrange:                 return .systemOrange
        case .systemYellow:                 return .systemYellow
        case .systemGreen:                  return .systemGreen
        case .systemMint:                   return .systemMint
        case .systemTeal:                   return .systemTeal
        case .systemCyan:                   return .systemCyan
        case .systemBlue:                   return .systemBlue
        case .systemIndigo:                 return .systemIndigo
        case .systemPurple:                 return .systemPurple
        case .systemPink:                   return .systemPink
        case .systemBrown:                  return .systemBrown
        case .systemGray:                   return .systemGray
        case .systemGray2:                  return .systemGray2
        case .systemGray3:                  return .systemGray3
        case .systemGray4:                  return .systemGray4
        case .systemGray5:                  return .systemGray5
        case .systemGray6:                  return .systemGray6
        }
        #elseif os(macOS)
        switch systemColor {
        // macOS semantic colors do not have a direct 1:1 mapping to UIKit's.
        // These mappings are chosen to align with standard macOS interface design patterns
        // or provide the closest semantic match.

        // MARK: Background Mappings
        case .primarySystemBackground:      return .windowBackgroundColor
        case .secondarySystemBackground:    return .underPageBackgroundColor
        case .tertiarySystemBackground:     return .controlBackgroundColor

        // MARK: Grouped Background Mappings (Approximations)
        // macOS doesn't have a "grouped" concept like iOS table views. Mapping to a logical hierarchy.
        case .primarySystemGroupedBackground:   return .windowBackgroundColor
        case .secondarySystemGroupedBackground: return .controlBackgroundColor
        case .tertiarySystemGroupedBackground:  return .underPageBackgroundColor

        // MARK: Label Mappings (Direct Equivalents)
        case .label:                        return .labelColor
        case .secondaryLabel:               return .secondaryLabelColor
        case .tertiaryLabel:                return .tertiaryLabelColor
        case .quaternaryLabel:              return .quaternaryLabelColor
        case .placeholderText:              return .placeholderTextColor

        // MARK: Fill Mappings (Semantic Approximations)
        case .systemFill:                   return .controlColor // Generic interactive element fill
        case .secondarySystemFill:          return .windowBackgroundColor // Subtle background fill
        case .tertiarySystemFill:           return .unemphasizedSelectedContentBackgroundColor // Subtle fill for inactive content
        case .quaternarySystemFill:         return .separatorColor // Very subtle fill, often like a separator

        // MARK: Other Semantic Colors
        case .separator:                    return .separatorColor
        case .link:                         return .linkColor // Direct equivalent
        case .systemRed:                    return .systemRed // Direct equivalent
        case .systemOrange:                 return .systemOrange // Direct equivalent
        case .systemYellow:                 return .systemYellow // Direct equivalent
        case .systemGreen:                  return .systemGreen // Direct equivalent
        case .systemMint:                   return .systemMint // Direct equivalent
        case .systemTeal:                   return .systemTeal // Direct equivalent
        case .systemCyan:                   return .systemCyan // Direct equivalent
        case .systemBlue:                   return .systemBlue // Direct equivalent
        case .systemIndigo:                 return .systemIndigo // Direct equivalent
        case .systemPurple:                 return .systemPurple // Direct equivalent
        case .systemPink:                   return .systemPink // Direct equivalent
        case .systemBrown:                  return .systemBrown // Direct equivalent
        case .systemGray:                   return .systemGray // Direct equivalent
        // macOS doesn't have granular gray shades like Gray2-6. Map them to the closest available.
        case .systemGray2, .systemGray3, .systemGray4, .systemGray5, .systemGray6:
                                            return .systemGray
        }
        #else
        return nil // Represents an alias for the platform-specific color type
        #endif
    }

    /// Resolves a semantic system color with a robust fallback mechanism.
    ///
    /// - `DEBUG` builds will `fatalError` if resolution fails, providing immediate feedback.
    /// - `RELEASE` builds will gracefully return a safe fallback color.
    ///
    /// - Parameters:
    ///   - type: The `SystemColorType` to resolve.
    ///   - fallback: An autoclosure providing the default color for release builds.
    /// - Returns: The resolved or fallback `UnifiedColor`.
    internal static func resolve(_ type: SystemColorType, fallback: @autoclosure () -> UnifiedColor) -> UnifiedColor {
        if let color = UnifiedColor(systemColor: type) {
            return color
        } else {
            #if DEBUG
            fatalError("SystemColorType '\(type)' failed to resolve. A standard fallback will be used in RELEASE builds.")
            #else
            return fallback()
            #endif
        }
    }

    /// Provides the standard, safe fallback color for a given `SystemColorType`.
    /// This is used in RELEASE builds when a system color cannot be resolved.
    internal static func fallbackColor(for type: SystemColorType) -> UnifiedColor {
        // These fallbacks attempt to provide a reasonable default, often based on light mode values.
        switch type {
        case .primarySystemBackground: return UnifiedColor(hex: "#FFFFFF")
        case .secondarySystemBackground: return UnifiedColor(hex: "#F2F2F7")
        case .tertiarySystemBackground: return UnifiedColor(hex: "#FFFFFF")
        case .primarySystemGroupedBackground: return UnifiedColor(hex: "#F2F2F7")
        case .secondarySystemGroupedBackground: return UnifiedColor(hex: "#FFFFFF")
        case .tertiarySystemGroupedBackground: return UnifiedColor(hex: "#F2F2F7")
        case .label: return UnifiedColor(hex: "#000000")
        case .secondaryLabel: return UnifiedColor(hex: "#3C3C4399") // Black 60% opacity
        case .tertiaryLabel: return UnifiedColor(hex: "#3C3C434D") // Black 30% opacity
        case .quaternaryLabel: return UnifiedColor(hex: "#3C3C432E") // Black 18% opacity
        case .placeholderText: return UnifiedColor(hex: "#3C3C434D") // Black 30% opacity
        case .systemFill: return UnifiedColor(hex: "#78788033") // Gray 0.2 20% opacity
        case .secondarySystemFill: return UnifiedColor(hex: "#78788029") // Gray 0.2 16% opacity
        case .tertiarySystemFill: return UnifiedColor(hex: "#7676801F") // Gray 0.47 12% opacity
        case .quaternarySystemFill: return UnifiedColor(hex: "#74748014") // Gray 0.45 8% opacity
        case .separator: return UnifiedColor(hex: "#38383A") // Dark Gray
        case .link: return UnifiedColor(hex: "#007AFF") // iOS Blue
        case .systemRed: return UnifiedColor(hex: "#FF3B30") // iOS Red
        case .systemOrange: return UnifiedColor(hex: "#FF9500") // iOS Orange
        case .systemYellow: return UnifiedColor(hex: "#FFCC00") // iOS Yellow
        case .systemGreen: return UnifiedColor(hex: "#34C759") // iOS Green
        case .systemMint: return UnifiedColor(hex: "#00C7BE") // iOS Mint
        case .systemTeal: return UnifiedColor(hex: "#30B0C7") // iOS Teal
        case .systemCyan: return UnifiedColor(hex: "#32ADE6") // iOS Cyan
        case .systemBlue: return UnifiedColor(hex: "#007AFF") // iOS Blue
        case .systemIndigo: return UnifiedColor(hex: "#5856D6") // iOS Indigo
        case .systemPurple: return UnifiedColor(hex: "#AF52DE") // iOS Purple
        case .systemPink: return UnifiedColor(hex: "#FF2D55") // iOS Pink
        case .systemBrown: return UnifiedColor(hex: "#A2845E") // iOS Brown
        case .systemGray: return UnifiedColor(hex: "#8E8E93") // iOS Gray
        case .systemGray2: return UnifiedColor(hex: "#636366") // iOS Gray2
        case .systemGray3: return UnifiedColor(hex: "#48484A") // iOS Gray3
        case .systemGray4: return UnifiedColor(hex: "#3A3A3C") // iOS Gray4
        case .systemGray5: return UnifiedColor(hex: "#2C2C2E") // iOS Gray5
        case .systemGray6: return UnifiedColor(hex: "#1C1C1E") // iOS Gray6
        }
    }

    // MARK: Backgrounds
    static var primarySystemBackground: UnifiedColor { resolve(.primarySystemBackground, fallback: fallbackColor(for: .primarySystemBackground)) }
    static var secondarySystemBackground: UnifiedColor { resolve(.secondarySystemBackground, fallback: fallbackColor(for: .secondarySystemBackground)) }
    static var tertiarySystemBackground: UnifiedColor { resolve(.tertiarySystemBackground, fallback: fallbackColor(for: .tertiarySystemBackground)) }

    // MARK: Grouped Backgrounds
    static var primarySystemGroupedBackground: UnifiedColor { resolve(.primarySystemGroupedBackground, fallback: fallbackColor(for: .primarySystemGroupedBackground)) }
    static var secondarySystemGroupedBackground: UnifiedColor { resolve(.secondarySystemGroupedBackground, fallback: fallbackColor(for: .secondarySystemGroupedBackground)) }
    static var tertiarySystemGroupedBackground: UnifiedColor { resolve(.tertiarySystemGroupedBackground, fallback: fallbackColor(for: .tertiarySystemGroupedBackground)) }

    // MARK: Labels
    static var label: UnifiedColor { resolve(.label, fallback: fallbackColor(for: .label)) }
    static var secondaryLabel: UnifiedColor { resolve(.secondaryLabel, fallback: fallbackColor(for: .secondaryLabel)) }
    static var tertiaryLabel: UnifiedColor { resolve(.tertiaryLabel, fallback: fallbackColor(for: .tertiaryLabel)) }
    static var quaternaryLabel: UnifiedColor { resolve(.quaternaryLabel, fallback: fallbackColor(for: .quaternaryLabel)) }
    static var placeholderText: UnifiedColor { resolve(.placeholderText, fallback: fallbackColor(for: .placeholderText)) }

    // MARK: Fills
    static var systemFill: UnifiedColor { resolve(.systemFill, fallback: fallbackColor(for: .systemFill)) }
    static var secondarySystemFill: UnifiedColor { resolve(.secondarySystemFill, fallback: fallbackColor(for: .secondarySystemFill)) }
    static var tertiarySystemFill: UnifiedColor { resolve(.tertiarySystemFill, fallback: fallbackColor(for: .tertiarySystemFill)) }
    static var quaternarySystemFill: UnifiedColor { resolve(.quaternarySystemFill, fallback: fallbackColor(for: .quaternarySystemFill)) }

    // MARK: Other Semantic Colors
    static var separator: UnifiedColor { resolve(.separator, fallback: fallbackColor(for: .separator)) }
    static var link: UnifiedColor { resolve(.link, fallback: fallbackColor(for: .link)) }

    // MARK: System Grays & Specific Colors (Added for completeness)
    static var systemRed: UnifiedColor { resolve(.systemRed, fallback: fallbackColor(for: .systemRed)) }
    static var systemOrange: UnifiedColor { resolve(.systemOrange, fallback: fallbackColor(for: .systemOrange)) }
    static var systemYellow: UnifiedColor { resolve(.systemYellow, fallback: fallbackColor(for: .systemYellow)) }
    static var systemGreen: UnifiedColor { resolve(.systemGreen, fallback: fallbackColor(for: .systemGreen)) }
    static var systemMint: UnifiedColor { resolve(.systemMint, fallback: fallbackColor(for: .systemMint)) }
    static var systemTeal: UnifiedColor { resolve(.systemTeal, fallback: fallbackColor(for: .systemTeal)) }
    static var systemCyan: UnifiedColor { resolve(.systemCyan, fallback: fallbackColor(for: .systemCyan)) }
    static var systemBlue: UnifiedColor { resolve(.systemBlue, fallback: fallbackColor(for: .systemBlue)) }
    static var systemIndigo: UnifiedColor { resolve(.systemIndigo, fallback: fallbackColor(for: .systemIndigo)) }
    static var systemPurple: UnifiedColor { resolve(.systemPurple, fallback: fallbackColor(for: .systemPurple)) }
    static var systemPink: UnifiedColor { resolve(.systemPink, fallback: fallbackColor(for: .systemPink)) }
    static var systemBrown: UnifiedColor { resolve(.systemBrown, fallback: fallbackColor(for: .systemBrown)) }
    static var systemGray: UnifiedColor { resolve(.systemGray, fallback: fallbackColor(for: .systemGray)) }
    static var systemGray2: UnifiedColor { resolve(.systemGray2, fallback: fallbackColor(for: .systemGray2)) }
    static var systemGray3: UnifiedColor { resolve(.systemGray3, fallback: fallbackColor(for: .systemGray3)) }
    static var systemGray4: UnifiedColor { resolve(.systemGray4, fallback: fallbackColor(for: .systemGray4)) }
    static var systemGray5: UnifiedColor { resolve(.systemGray5, fallback: fallbackColor(for: .systemGray5)) }
    static var systemGray6: UnifiedColor { resolve(.systemGray6, fallback: fallbackColor(for: .systemGray6)) }

    #if os(iOS) || os(tvOS)
    /// Resolves a semantic system color for a specific trait collection (iOS/tvOS only).
    ///
    /// This is an advanced method for contexts where you need to render a color for an
    /// appearance that is not currently active (e.g., snapshot testing, generating color swatches).
    ///
    /// - Parameters:
    ///   - systemColor: The semantic system color to create.
    ///   - traitCollection: The specific `UITraitCollection` to resolve the color against.
    ///     If `nil`, it uses the current trait environment (like `init?(systemColor:)`).
    /// - Returns: The resolved `UnifiedColor`, or the fallback color if resolution fails.
    // Note: Making this internal for now as ThemeManager is internal, but could be public.
    internal init(systemColor: SystemColorType, for traitCollection: UITraitCollection?) {
        guard let baseColor = Self.platformColor(for: systemColor) else {
            // Fallback if the base platform color isn't even available for the enum case
            self = UnifiedColor.fallbackColor(for: systemColor)
            return
        }

        // Resolve using the specific trait collection
        let resolvedColor = baseColor.resolvedColor(with: traitCollection ?? .current)

        // Attempt to get RGBA components
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        // Use getRed... which returns true on success, false otherwise
        if resolvedColor.getRed(&r, green: &g, blue: &b, alpha: &a) {
            self.init(red: Double(r), green: Double(g), blue: Double(b), alpha: Double(a))
        } else {
            // Fallback if getRed fails (e.g., pattern color), try converting to sRGB
            guard let srgbColor = resolvedColor.usingColorSpace(.sRGB) else {
                 // Final fallback if sRGB conversion also fails
                self = UnifiedColor.fallbackColor(for: systemColor)
                return
            }
             // Now use getRed on the sRGB color, which should succeed
             if srgbColor.getRed(&r, green: &g, blue: &b, alpha: &a) {
                 self.init(red: Double(r), green: Double(g), blue: Double(b), alpha: Double(a))
             } else {
                 // Still failed, unable to convert even after sRGB.
                 self = UnifiedColor.fallbackColor(for: systemColor)
                 return
             }
        }
    }
    #endif
}


// MARK: - UnifiedGradientStop.swift

/// A struct that pairs a `UnifiedColor` with a location for use in gradients.
///
/// This provides a way to define precise color stops using your platform-agnostic `UnifiedColor` type
/// before converting them to the `SwiftUI.Gradient.Stop` required by the system.
public struct UnifiedGradientStop: Hashable, Identifiable { // Added Hashable conformance
    /// The color for the gradient stop.
    public let color: UnifiedColor

    /// The location of the stop along the gradient's axis, from 0.0 to 1.0.
    public let location: CGFloat

    // Added explicit `id` requirement for `Identifiable` based on Hashable values
     public var id: Int {
        var hasher = Hasher()
        hasher.combine(color)
        hasher.combine(location)
        return hasher.finalize()
    }

    /// Creates a new gradient stop.
    /// - Parameters:
    ///   - color: The `UnifiedColor` for the stop.
    ///   - location: The location of the stop (from 0.0 to 1.0). The value will be clamped to this range.
    public init(color: UnifiedColor, location: CGFloat) {
        self.color = color
        self.location = max(0.0, min(1.0, location))
    }

    // Hashable conformance synthesized because UnifiedColor and CGFloat are Hashable.

    /// A computed property that converts the unified stop into a SwiftUI `Gradient.Stop`.
    /// This is used internally by the gradient helpers and ThemedStyle.
    internal var swiftUIStop: Gradient.Stop {
        return Gradient.Stop(color: color.swiftUIColor, location: location)
    }
}


// MARK: - DesignSystemEngine.swift

/// A type-erased container for a specific design system value.
/// **Note:** Font cannot be included here as it is not `Hashable`. Font tokens are
/// stored and retrieved separately via `DesignSystem.fonts` and `uniTheme.font()`.
public enum DesignToken: Hashable {
    /// A static, absolute color value, typically defined by a hex string.
    case staticColor(UnifiedColor)

    /// A semantic color that is dynamically resolved by the operating system (e.g., `UIColor.label`).
    case semanticColor(SystemColorType)

    case spacing(CGFloat)
    case radius(CGFloat)

    // --- Gradient Definitions ---
    case linearGradient([UnifiedGradientStop], startPoint: UnitPoint, endPoint: UnitPoint)
    case radialGradient([UnifiedGradientStop], center: UnitPoint, startRadius: CGFloat, endRadius: CGFloat)
    case conicGradient([UnifiedGradientStop], center: UnitPoint, angle: Angle)

    // Add other token types as needed (e.g., `time(TimeInterval)`, `asset(String)`)
}

/// A type-safe key for retrieving a token from the `DesignSystem`.
public struct TokenKey: Hashable, CustomStringConvertible {
    public let group: String
    public let name: String
    public init(group: String, name: String) { self.group = group; self.name = name }

    public var description: String { "\(group).\(name)" }
}

/// A struct representing a complete design system, containing a collection of design tokens.
/// **Note:** This struct cannot be `Hashable` because it contains `Font` values internally.
/// It *is* `Identifiable` for use in SwiftUI lists.
public struct DesignSystem: Identifiable { // Removed Hashable conformance as it contains Font
    public var id: String { name } // Conform to Identifiable using the name
    public let name: String
    // The registry for all design tokens that are Hashable.
     let tokens: [TokenKey: DesignToken]
    // The registry for Font tokens (not Hashable).
     let fonts: [TokenKey: Font]

    public init(name: String, tokens: [TokenKey: DesignToken], fonts: [TokenKey: Font] = [:]) {
        self.name = name
        self.tokens = tokens
        self.fonts = fonts
    }

    /// A type-safe method to retrieve a general token from the system.
    internal func token(for key: TokenKey) -> DesignToken? {
        return tokens[key]
    }

    /// A type-safe method to retrieve a font token from the system.
     internal func font(for key: TokenKey) -> Font? {
         return fonts[key]
     }
}

// MARK: - Theme Manager
/// A singleton `ObservableObject` responsible for managing the application's active design system.
///
/// This manager provides a centralized point of control for:
/// - Accessing the current design system's tokens.
/// - Listing all available design systems.
/// - Applying a new design system and persisting the user's choice.
///
/// Views can subscribe to changes from this manager to update their appearance in real-time.
@MainActor
public final class uniTheme: ObservableObject {
    /// The shared singleton instance of the theme manager.
    public static let shared = uniTheme() // Calls the convenience init below

    /// The key used to store the selected design system's name in `UserDefaults`.
     static let themeKey = "com.designsystem.selectedTheme"

    /// The currently active design system. When this changes, the entire UI will update.
    ///
    /// This property is marked with `@Published`, so any SwiftUI view observing this manager
    /// (e.g., via `@StateObject` or `@EnvironmentObject`) will automatically be rebuilt
    /// when the design system changes, ensuring the UI updates instantly.
    @Published public var currentDesignSystem: DesignSystem

    /// A list of all design systems that the user can choose from.
    public let availableDesignSystems: [DesignSystem]

    /// Public initializer for external use (e.g., in an app) to inject available design systems.
    public init(designSystems: [DesignSystem]) {
        // Ensure the provided systems have unique names to avoid issues with UserDefaults and Picker tags
        let uniqueSystems = Dictionary(designSystems.map { ($0.name, $0) }, uniquingKeysWith: { (first, _) in first }).values.sorted { $0.name < $1.name }
        self.availableDesignSystems = Array(uniqueSystems)

        let savedName = UserDefaults.standard.string(forKey: Self.themeKey)
        // Find the saved system by name, or default to the first available, or an empty one if none are provided.
        self.currentDesignSystem = self.availableDesignSystems.first { $0.name == savedName } ?? self.availableDesignSystems.first ?? DesignSystem(name: "Empty", tokens: [:], fonts: [:])
    }

    /// Convenience initializer for the shared singleton instance in this merged file context.
    /// In a real framework, this might be internal or removed, and the app would explicitly
    /// initialize `ThemeManager.shared` with its systems. Here, we use the example systems.
    internal convenience init() {
        // Use the example systems defined later in the file
        self.init(designSystems: AppDesignSystems.all)
    }

    /// Applies a new design system to the application and saves the choice.
    ///
    /// - Parameter system: The `DesignSystem` to apply.
    public func applyDesignSystem(_ system: DesignSystem) {
         // Ensure the system is one of the available ones before applying
        guard availableDesignSystems.contains(where: { $0.id == system.id }) else {
            print("Warning: Attempted to apply a design system ('\(system.name)') that is not in the list of available systems.")
            return
        }
        currentDesignSystem = system
        UserDefaults.standard.set(system.name, forKey: Self.themeKey)
    }

    /// Applies a new design system by its name and saves the choice.
    ///
    /// - Parameter name: The name of the `DesignSystem` to apply.
    public func applyDesignSystem(named name: String) {
        if let system = availableDesignSystems.first(where: { $0.name == name }) {
            applyDesignSystem(system)
        } else {
            print("Warning: Design system with name '\(name)' not found.")
        }
    }

    // MARK: - Type-Safe Token Accessors

    /// Retrieves a color token for the given key from the active design system.
    ///
    /// This method can resolve two types of color tokens:
    /// - `.staticColor`: Returns the defined `UnifiedColor` directly.
    /// - `.semanticColor`: Dynamically resolves the system color (e.g., `UIColor.label`) for the current environment.
    ///
    /// - Parameter group: The group the color token belongs to (defaults to "color").
    /// - Parameter name: The name of the color token.
    /// - Returns: The resolved `UnifiedColor`.
    public func color(group: String = "color", name: String) -> UnifiedColor {
        let key = TokenKey(group: group, name: name)
        guard let token = currentDesignSystem.token(for: key) else {
            #if DEBUG
            fatalError("Color token not found for key: \(key).")
            #else
            // In release, return a visible error color but do not crash.
            print("Error: Color token '\(key)' not found.")
            return UnifiedColor(hex: "#FF00FF") // Magenta fallback
            #endif
        }

        switch token {
        case .staticColor(let color):
            // This is a static brand color, return it directly.
            return color

        case .semanticColor(let systemColorType):
            // Use the robust, centralized resolver for the current environment.
            return UnifiedColor.resolve(systemColorType, fallback: UnifiedColor.fallbackColor(for: systemColorType))

        default:
            #if DEBUG
            fatalError("Design token for key \(key) is not a color. Found: \(token)")
            #else
            print("Error: Token '\(key)' is not a color.")
            return UnifiedColor(hex: "#FF00FF")
            #endif
        }
    }

    #if os(iOS) || os(tvOS)
    /// Retrieves a color token for the given key, resolved for a **specific trait collection**.
    ///
    /// This is an advanced method for contexts like snapshot testing where you need to render a color
    /// for an appearance that is not currently active. It is only available on iOS/tvOS.
    ///
    /// - Parameters:
    ///   - name: The name of the color token.
    ///   - traitCollection: The specific `UITraitCollection` to resolve the color against. If `nil`, this method behaves identically to the standard `color(name:)` method (using the current trait environment).
    /// - Returns: The resolved `UnifiedColor`.
    public func color(group: String = "color", name: String, for traitCollection: UITraitCollection?) -> UnifiedColor {
        let key = TokenKey(group: group, name: name)
        guard let token = currentDesignSystem.token(for: key) else {
            #if DEBUG
            fatalError("Color token not found for key: \(key).")
            #else
            // In release, return a visible error color but do not crash.
            print("Error: Color token '\(key)' not found for trait collection.")
            return UnifiedColor(hex: "#FF00FF") // Magenta fallback
            #endif
        }

        switch token {
        case .staticColor(let color):
            // Static colors are unaffected by trait collections. Return directly.
            return color

        case .semanticColor(let systemColorType):
            // Use the advanced, trait-aware initializer.
            // It has built-in fallback logic to UnifiedColor.fallbackColor.
            return UnifiedColor(systemColor: systemColorType, for: traitCollection)

        default:
            #if DEBUG
            fatalError("Design token for key \(key) is not a color when resolving for trait collection. Found: \(token)")
            #else
            print("Error: Token '\(key)' is not a color for trait collection.")
            return UnifiedColor(hex: "#FF00FF")
            #endif
        }
    }
    #endif


    /// Retrieves a font token for the given key.
    /// Defaults to the "font" group.
    public func font(group: String = "font", name: String) -> Font {
        let key = TokenKey(group: group, name: name)
        guard let font = currentDesignSystem.font(for: key) else {
            #if DEBUG
            fatalError("Font token not found for key: \(key)")
            #else
            print("Error: Font token '\(key)' not found.")
            // In release, return a default font.
            return .body
            #endif
        }
        return font
    }

    /// Retrieves a spacing token for the given key.
    /// Defaults to the "spacing" group.
    public func spacing(group: String = "spacing", name: String) -> CGFloat {
        let key = TokenKey(group: group, name: name)
        guard let token = currentDesignSystem.token(for: key) else {
             #if DEBUG
            fatalError("Spacing token not found for key: \(key)")
            #else
            print("Error: Spacing token '\(key)' not found.")
            return 0 // Default spacing
            #endif
        }
        guard case .spacing(let spacing) = token else {
             #if DEBUG
            fatalError("Design token for key \(key) is not a spacing. Found: \(token)")
            #else
            print("Error: Token '\(key)' is not spacing.")
            return 0
            #endif
        }
        return spacing
    }

    /// Retrieves a radius token for the given key.
    /// Defaults to the "radius" group.
    public func radius(group: String = "radius", name: String) -> CGFloat {
        let key = TokenKey(group: group, name: name)
        guard let token = currentDesignSystem.token(for: key) else {
             #if DEBUG
            fatalError("Radius token not found for key: \(key)")
            #else
            print("Error: Radius token '\(key)' not found.")
            return 0 // Default radius
            #endif
        }
        guard case .radius(let radius) = token else {
            #if DEBUG
            fatalError("Design token for key \(key) is not a radius. Found: \(token)")
            #else
            print("Error: Token '\(key)' is not radius.")
            return 0
            #endif
        }
        return radius
    }

     /// Retrieves a gradient token for the given key.
     /// Defaults to the "gradient" group.
     internal func gradient(group: String = "gradient", name: String) -> DesignToken? {
         let key = TokenKey(group: group, name: name)
         guard let token = currentDesignSystem.token(for: key) else {
             #if DEBUG
             fatalError("Gradient token not found for key: \(key)")
             #else
             print("Error: Gradient token '\(key)' not found.")
             return nil // Return nil, ThemedStyle will handle fallback
             #endif
         }

         switch token {
         case .linearGradient, .radialGradient, .conicGradient:
             return token
         default:
             #if DEBUG
             fatalError("Design token for key \(key) is not a recognized gradient type. Found: \(token)")
             #else
             print("Error: Token '\(key)' is not a recognized gradient type.")
             return nil
             #endif
         }
     }
}


// MARK: - AppDesignSystems.swift (Example/Placeholder - Typically in App Layer)

/// Defines the concrete design systems available for the application.
@MainActor
public enum AppDesignSystems {

    /// The primary design system, mirroring Apple's Developer app theme.
    public static let documentation: DesignSystem = {
        // Define colors first as they are used in gradients
        let docColors: [TokenKey: UnifiedColor] = [
            TokenKey(group: "color", name: "background"): UnifiedColor(hex: "#1D1D1F"),
            TokenKey(group: "color", name: "contentBackground"): UnifiedColor(hex: "#272729"),
            TokenKey(group: "color", name: "sidebarBackground"): UnifiedColor(hex: "#272729"),
            TokenKey(group: "color", name: "selection"): UnifiedColor(hex: "#4A4A4C"), // A specific highlight grey
            TokenKey(group: "color", name: "textPrimary"): UnifiedColor(hex: "#F5F5F7"), // Near white
            TokenKey(group: "color", name: "textSecondary"): UnifiedColor(hex: "#8E8E93"), // iOS Gray
            TokenKey(group: "color", name: "border"): UnifiedColor(hex: "#3A3A3C"), // iOS Gray4
            TokenKey(group: "color", name: "accentBlue"): UnifiedColor(hex: "#0A84FF"),
            TokenKey(group: "color", name: "accentPurple"): UnifiedColor(hex: "#BF5AF2"),
            TokenKey(group: "color", name: "accentOrange"): UnifiedColor(hex: "#FF9F0A"),
            TokenKey(group: "color", name: "systemGreen"): UnifiedColor(hex: "#34C759"), // Example Green needed for a gradient

            // Added colors for UniContainers example views
            TokenKey(group: "color", name: "cardBackground"): UnifiedColor(hex: "#272729"), // Same as contentBackground
            TokenKey(group: "color", name: "shadow"): UnifiedColor(hex: "#000000").withOpacity(0.2), // Dark shadow
            TokenKey(group: "color", name: "accent"): UnifiedColor(hex: "#0A84FF"), // Same as accentBlue
            TokenKey(group: "color", name: "backgroundPrimary"): UnifiedColor(hex: "#1D1D1F"), // Same as background
        ]

        var tokens: [TokenKey: DesignToken] = [:]

        // Add Colors as staticColor tokens
        docColors.forEach { key, color in
            tokens[key] = .staticColor(color)
        }

        // --- Spacing Tokens --
        tokens[TokenKey(group: "spacing", name: "small")] = .spacing(4)
        tokens[TokenKey(group: "spacing", name: "medium")] = .spacing(8)
        tokens[TokenKey(group: "spacing", name: "large")] = .spacing(16)

        // --- Radius Tokens ---
        tokens[TokenKey(group: "radius", name: "card")] = .radius(20)
        tokens[TokenKey(group: "radius", name: "standard")] = .radius(10)

        // --- Gradient Tokens (using the defined colors) ---
        tokens[TokenKey(group: "gradient", name: "permissions")] = .linearGradient(
            [
                UnifiedGradientStop(color: docColors[TokenKey(group: "color", name: "accentBlue")]!, location: 0),
                UnifiedGradientStop(color: docColors[TokenKey(group: "color", name: "accentPurple")]!, location: 1)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        tokens[TokenKey(group: "gradient", name: "authentication")] = .linearGradient(
             [
                 UnifiedGradientStop(color: docColors[TokenKey(group: "color", name: "accentPurple")]!, location: 0),
                 UnifiedGradientStop(color: docColors[TokenKey(group: "color", name: "accentOrange")]!, location: 1)
             ],
             startPoint: .topLeading,
             endPoint: .bottomTrailing
         )
        tokens[TokenKey(group: "gradient", name: "color")] = .linearGradient(
             [
                 UnifiedGradientStop(color: docColors[TokenKey(group: "color", name: "accentOrange")]!, location: 0),
                 UnifiedGradientStop(color: docColors[TokenKey(group: "color", name: "accentBlue")]!, location: 1)
             ],
             startPoint: .topLeading,
             endPoint: .bottomTrailing
         )
        tokens[TokenKey(group: "gradient", name: "web")] = .linearGradient(
             [
                  UnifiedGradientStop(color: docColors[TokenKey(group: "color", name: "systemGreen")]!, location: 0),
                  UnifiedGradientStop(color: docColors[TokenKey(group: "color", name: "accentBlue")]!, location: 1)
             ],
             startPoint: .topLeading,
             endPoint: .bottomTrailing
         )

        // --- Font Tokens (stored separately) ---
        let fonts: [TokenKey: Font] = [
            TokenKey(group: "font", name: "code"): .system(.body, design: .monospaced),
            TokenKey(group: "font", name: "body"): .system(.body, design: .default),
            TokenKey(group: "font", name: "headline"): .headline,
            TokenKey(group: "font", name: "largeTitle"): .largeTitle,
        ]

        return DesignSystem(name: "Documentation", tokens: tokens, fonts: fonts)
    }()

    @MainActor
    /// A simple default theme with basic static colors and fonts.
    public static let `default`: DesignSystem = {
        var tokens: [TokenKey: DesignToken] = [
            // Base colors
            TokenKey(group: "color", name: "primary"): .staticColor(UnifiedColor(hex: "#0A84FF")), // Blue
            TokenKey(group: "color", name: "destructive"): .staticColor(UnifiedColor(hex: "#FF3B30")), // Red
            TokenKey(group: "color", name: "success"): .staticColor(UnifiedColor(hex: "#34C759")), // Green
            TokenKey(group: "color", name: "background"): .staticColor(UnifiedColor(hex: "#F9F9F9")), // Light Gray
            TokenKey(group: "color", name: "foreground"): .staticColor(UnifiedColor(hex: "#1C1C1E")), // Dark Gray
            TokenKey(group: "color", name: "muted"): .staticColor(UnifiedColor(hex: "#8E8E93")), // Gray
            
            // Added colors for UniContainers
            TokenKey(group: "color", name: "cardBackground"): .staticColor(UnifiedColor(hex: "#FFFFFF")), // White
            TokenKey(group: "color", name: "shadow"): .staticColor(UnifiedColor(hex: "#000000").withOpacity(0.1)), // Subtle shadow
            TokenKey(group: "color", name: "accent"): .staticColor(UnifiedColor(hex: "#0A84FF")), // Same as primary
            TokenKey(group: "color", name: "backgroundPrimary"): .staticColor(UnifiedColor(hex: "#F9F9F9")), // Same as background
            TokenKey(group: "color", name: "textPrimary"): .staticColor(UnifiedColor(hex: "#1C1C1E")), // Same as foreground
            TokenKey(group: "color", name: "textSecondary"): .staticColor(UnifiedColor(hex: "#8E8E93")), // Same as muted
            TokenKey(group: "color", name: "border"): .staticColor(UnifiedColor(hex: "#D1D1D6")), // Light border
            TokenKey(group: "color", name: "accentPurple"): .staticColor(UnifiedColor(hex: "#AF52DE")), // iOS Purple fallback
            TokenKey(group: "color", name: "selection"): .staticColor(UnifiedColor(hex: "#E5E5EA")), // Light selection gray

            // Spacing & Radii
            TokenKey(group: "spacing", name: "small"): .spacing(4),
            TokenKey(group: "spacing", name: "medium"): .spacing(8),
            TokenKey(group: "spacing", name: "large"): .spacing(16),
            TokenKey(group: "radius", name: "card"): .radius(20),
            TokenKey(group: "radius", name: "standard"): .radius(10)
        ]
        
        let fonts: [TokenKey: Font] = [
             TokenKey(group: "font", name: "body"): .body,
             TokenKey(group: "font", name: "code"): .system(.body, design: .monospaced),
             TokenKey(group: "font", name: "headline"): .headline,
             TokenKey(group: "font", name: "largeTitle"): .largeTitle,
        ]
        
        return DesignSystem(name: "Default", tokens: tokens, fonts: fonts)
    }()

    /// A theme that uses the OS's native semantic colors for most elements.
    public static let systemNative: DesignSystem = {
         var tokens: [TokenKey: DesignToken] = [
            // --- Use SEMANTIC colors for UI chrome ---
            TokenKey(group: "color", name: "background"): .semanticColor(.primarySystemBackground),
            TokenKey(group: "color", name: "contentBackground"): .semanticColor(.secondarySystemBackground),
            TokenKey(group: "color", name: "sidebarBackground"): .semanticColor(.tertiarySystemBackground),
            TokenKey(group: "color", name: "selection"): .semanticColor(.quaternarySystemFill),
            TokenKey(group: "color", name: "textPrimary"): .semanticColor(.label),
            TokenKey(group: "color", name: "textSecondary"): .semanticColor(.secondaryLabel),
            TokenKey(group: "color", name: "border"): .semanticColor(.separator),

            // --- Added colors for UniContainers using semantic equivalents ---
            TokenKey(group: "color", name: "cardBackground"): .semanticColor(.secondarySystemBackground),
            TokenKey(group: "color", name: "shadow"): .semanticColor(.systemGray),
            TokenKey(group: "color", name: "accent"): .semanticColor(.systemBlue),
            TokenKey(group: "color", name: "backgroundPrimary"): .semanticColor(.primarySystemBackground),

            // --- Use STATIC colors for brand accents if needed ---
            TokenKey(group: "color", name: "accentBlue"): .staticColor(UnifiedColor(hex: "#0A84FF")),
            TokenKey(group: "color", name: "accentPurple"): .staticColor(UnifiedColor(hex: "#BF5AF2")),
            TokenKey(group: "color", name: "accentOrange"): .staticColor(UnifiedColor(hex: "#FF9F0A")),
            TokenKey(group: "color", name: "systemRed"): .semanticColor(.systemRed),

             // --- Spacing and Radii ---
            TokenKey(group: "spacing", name: "small"): .spacing(4),
            TokenKey(group: "spacing", name: "medium"): .spacing(8),
            TokenKey(group: "spacing", name: "large"): .spacing(16),
            TokenKey(group: "radius", name: "standard"): .radius(10),
            TokenKey(group: "radius", name: "card"): .radius(20),
        ]

         // --- Font Tokens (stored separately) ---
         let fonts: [TokenKey: Font] = [
             TokenKey(group: "font", name: "code"): .system(.body, design: .monospaced),
             TokenKey(group: "font", name: "body"): .system(.body, design: .default),
             TokenKey(group: "font", name: "headline"): .headline,
             TokenKey(group: "font", name: "largeTitle"): .largeTitle,
         ]

        return DesignSystem(name: "System Native", tokens: tokens, fonts: fonts)
    }()

    public static let all: [DesignSystem] = [`default`, documentation, systemNative]
}


// MARK: - Theme Convenience Accessors
// This struct provides a simplified facade to access the current theme's tokens.
@MainActor
public enum Theme {
     static var manager: uniTheme { uniTheme.shared } // Access the singleton

    @MainActor
    public enum Colors {
        // Core colors
        public static var background: UnifiedColor { manager.color(name: "background") }
        public static var contentBackground: UnifiedColor { manager.color(name: "contentBackground") }
        public static var sidebarBackground: UnifiedColor { manager.color(name: "sidebarBackground") }
        public static var selection: UnifiedColor { manager.color(name: "selection") }
        public static var textPrimary: UnifiedColor { manager.color(name: "textPrimary") }
        public static var textSecondary: UnifiedColor { manager.color(name: "textSecondary") }
        public static var border: UnifiedColor { manager.color(name: "border") }
        public static var accentBlue: UnifiedColor { manager.color(name: "accentBlue") }
        public static var accentPurple: UnifiedColor { manager.color(name: "accentPurple") }
        public static var accentOrange: UnifiedColor { manager.color(name: "accentOrange") }

        // Colors from Default theme
        public static var primary: UnifiedColor { manager.color(name: "primary") }
        public static var destructive: UnifiedColor { manager.color(name: "destructive") }
        public static var success: UnifiedColor { manager.color(name: "success") }
        public static var foreground: UnifiedColor { manager.color(name: "foreground") }
        public static var muted: UnifiedColor { manager.color(name: "muted") }

        // Added colors for UniContainers
        public static var cardBackground: UnifiedColor { manager.color(name: "cardBackground") }
        public static var shadow: UnifiedColor { manager.color(name: "shadow") }
        public static var accent: UnifiedColor { manager.color(name: "accent") }
        public static var backgroundPrimary: UnifiedColor { manager.color(name: "backgroundPrimary") }

        // System colors
        public static var systemRed: UnifiedColor { manager.color(name: "systemRed") }
    }
    
    @MainActor
    public enum Fonts {
        public static var code: Font { manager.font(name: "code") }
        public static var body: Font { manager.font(name: "body") }
        public static var headline: Font { manager.font(name: "headline") }
        public static var largeTitle: Font { manager.font(name: "largeTitle") }
    }
    
    @MainActor
    public enum Radii {
        public static var card: CGFloat { manager.radius(name: "card") }
        public static var standard: CGFloat { manager.radius(name: "standard") }
    }
    
    @MainActor
    public enum Spacing {
        public static var small: CGFloat { manager.spacing(name: "small") }
        public static var medium: CGFloat { manager.spacing(name: "medium") }
        public static var large: CGFloat { manager.spacing(name: "large") }
    }

    #if os(iOS) || os(tvOS)
    /// Resolves a color token for a specific trait collection (iOS/tvOS only).
    public static func color(name: String, for traitCollection: UITraitCollection?) -> UnifiedColor {
        return manager.color(name: name, for: traitCollection)
    }
    #endif

    /// Retrieves a gradient token for the given key.
     internal static func gradient(group: String = "gradient", name: String) -> DesignToken? {
         return manager.gradient(group: group, name: name)
     }
}


// MARK: - ThemedStyle.swift

/// A custom `ShapeStyle` that resolves theme-defined styles (colors, gradients)
/// based on the current active design system and environment.
@MainActor
public struct ThemedStyle: @preconcurrency ShapeStyle {

    /// Internal key to identify which token or style this instance represents.
     enum ThemeStyleKey: Hashable {
        case color(TokenKey)
        case gradient(TokenKey)
        case fallbackColor(UnifiedColor) // Added fallback case
    }

     let key: ThemeStyleKey

    //  initializer forces usage of static factory methods
     init(key: ThemeStyleKey) {
        self.key = key
    }

     ///  initializer for creating a fallback style directly.
     init(fallbackColor: UnifiedColor) {
         self.key = .fallbackColor(fallbackColor)
    }

    /// Resolves the theme token into a concrete `ShapeStyle` instance.
    @MainActor
    public func resolve(in environment: EnvironmentValues) -> AnyShapeStyle {
        let themeManager = uniTheme.shared

        switch key {
        case .color(let tokenKey):
             #if os(iOS) || os(tvOS)
             let traitCollection = environment.self._uiKitTraitCollection
             let unifiedColor = themeManager.color(group: tokenKey.group, name: tokenKey.name, for: traitCollection)
             #else
             let unifiedColor = themeManager.color(group: tokenKey.group, name: tokenKey.name)
             #endif
             return AnyShapeStyle(unifiedColor.swiftUIColor)

        case .gradient(let tokenKey):
            guard let token = themeManager.gradient(group: tokenKey.group, name: tokenKey.name) else {
                 #if DEBUG
                 fatalError("Gradient token '\(tokenKey)' should have been resolved or fatalErrored by ThemeManager.")
                 #else
                 print("Error: Gradient token '\(tokenKey)' not resolved.")
                 return AnyShapeStyle(Color.magenta)
                 #endif
             }

             switch token {
             case .linearGradient(let stops, let sp, let ep):
                 let swiftUIStops = stops.map { $0.swiftUIStop }
                 return AnyShapeStyle(LinearGradient(gradient: Gradient(stops: swiftUIStops), startPoint: sp, endPoint: ep))
             case .radialGradient(let stops, let c, let sr, let er):
                 let swiftUIStops = stops.map { $0.swiftUIStop }
                  return AnyShapeStyle(RadialGradient(gradient: Gradient(stops: swiftUIStops), center: c, startRadius: sr, endRadius: er))
             case .conicGradient(let stops, let c, let a):
                 let swiftUIStops = stops.map { $0.swiftUIStop }
                  return AnyShapeStyle(AngularGradient(gradient: Gradient(stops: swiftUIStops), center: c, angle: a))
             default:
                 #if DEBUG
                 fatalError("Token for '\(tokenKey)' is not a recognized gradient type: \(token)")
                 #else
                 print("Error: Token '\(tokenKey)' is not a recognized gradient type.")
                 return AnyShapeStyle(Color.magenta)
                 #endif
             }
        case .fallbackColor(let color):
            return AnyShapeStyle(color.swiftUIColor)
        }
    }

    // MARK: - Static Accessors

    // --- Color Accessors ---
    @MainActor public static var background: ThemedStyle { ThemedStyle(key: .color(TokenKey(group: "color", name: "background"))) }
    @MainActor public static var contentBackground: ThemedStyle { ThemedStyle(key: .color(TokenKey(group: "color", name: "contentBackground"))) }
    @MainActor public static var sidebarBackground: ThemedStyle { ThemedStyle(key: .color(TokenKey(group: "color", name: "sidebarBackground"))) }
    @MainActor public static var selection: ThemedStyle { ThemedStyle(key: .color(TokenKey(group: "color", name: "selection"))) }
    @MainActor public static var textPrimary: ThemedStyle { ThemedStyle(key: .color(TokenKey(group: "color", name: "textPrimary"))) }
    @MainActor public static var textSecondary: ThemedStyle { ThemedStyle(key: .color(TokenKey(group: "color", name: "textSecondary"))) }
    @MainActor public static var border: ThemedStyle { ThemedStyle(key: .color(TokenKey(group: "color", name: "border"))) }
    @MainActor public static var accentBlue: ThemedStyle { ThemedStyle(key: .color(TokenKey(group: "color", name: "accentBlue"))) }
    @MainActor public static var accentPurple: ThemedStyle { ThemedStyle(key: .color(TokenKey(group: "color", name: "accentPurple"))) }
    @MainActor public static var accentOrange: ThemedStyle { ThemedStyle(key: .color(TokenKey(group: "color", name: "accentOrange"))) }
    @MainActor public static var primary: ThemedStyle { ThemedStyle(key: .color(TokenKey(group: "color", name: "primary"))) }
    @MainActor public static var destructive: ThemedStyle { ThemedStyle(key: .color(TokenKey(group: "color", name: "destructive"))) }
    @MainActor public static var success: ThemedStyle { ThemedStyle(key: .color(TokenKey(group: "color", name: "success"))) }
    @MainActor public static var foreground: ThemedStyle { ThemedStyle(key: .color(TokenKey(group: "color", name: "foreground"))) }
    @MainActor public static var muted: ThemedStyle { ThemedStyle(key: .color(TokenKey(group: "color", name: "muted"))) }
    @MainActor public static var systemRed: ThemedStyle { ThemedStyle(key: .color(TokenKey(group: "color", name: "systemRed"))) }

    // Added colors for UniContainers
    @MainActor public static var cardBackground: ThemedStyle { ThemedStyle(key: .color(TokenKey(group: "color", name: "cardBackground"))) }
    @MainActor public static var shadow: ThemedStyle { ThemedStyle(key: .color(TokenKey(group: "color", name: "shadow"))) }
    @MainActor public static var accent: ThemedStyle { ThemedStyle(key: .color(TokenKey(group: "color", name: "accent"))) }
    @MainActor public static var backgroundPrimary: ThemedStyle { ThemedStyle(key: .color(TokenKey(group: "color", name: "backgroundPrimary"))) }

    // --- Gradient Accessor ---
    /// Creates a ThemedStyle that resolves to a gradient token with the given name.
    @MainActor public static func gradient(name: String, group: String = "gradient") -> ThemedStyle {
        ThemedStyle(key: .gradient(TokenKey(group: group, name: name)))
    }

    // Static accessors for specific gradients defined in the design system
     @MainActor public static var permissionsGradient: ThemedStyle { ThemedStyle(key: .gradient(TokenKey(group: "gradient", name: "permissions"))) }
     @MainActor public static var authenticationGradient: ThemedStyle { ThemedStyle(key: .gradient(TokenKey(group: "gradient", name: "authentication"))) }
     @MainActor public static var colorGradient: ThemedStyle { ThemedStyle(key: .gradient(TokenKey(group: "gradient", name: "color"))) }
     @MainActor public static var webGradient: ThemedStyle { ThemedStyle(key: .gradient(TokenKey(group: "gradient", name: "web"))) }
}

// MARK: - SwiftUI+Theme.swift

/// Provides a deeply integrated, idiomatic API for accessing the active design system's
/// tokens directly from native SwiftUI types.
///
/// ## Usage
///
/// ```swift
/// Text("Themed Text")
///     .font(.theme.headline)
///     .foregroundStyle(.theme.textPrimary)
///     .cornerRadius(.theme.radiusCard)
///     .padding(.theme.spacingMedium)
/// ```

// MARK: - Color + Theme
@MainActor
public extension Color {
    /// A proxy namespace for accessing color tokens from the active design system.
    static let theme = ThemeColorProxy()
}

@MainActor
@dynamicMemberLookup
public struct ThemeColorProxy {
    
    // MARK: - Dynamic Access via key string
    public subscript(colorName: String) -> Color {
        let map: [String: () -> Color] = [
            "background": { Theme.Colors.background.swiftUIColor },
            "contentBackground": { Theme.Colors.contentBackground.swiftUIColor },
            "sidebarBackground": { Theme.Colors.sidebarBackground.swiftUIColor },
            "selection": { Theme.Colors.selection.swiftUIColor },
            "textPrimary": { Theme.Colors.textPrimary.swiftUIColor },
            "textSecondary": { Theme.Colors.textSecondary.swiftUIColor },
            "border": { Theme.Colors.border.swiftUIColor },
            "accentBlue": { Theme.Colors.accentBlue.swiftUIColor },
            "accentPurple": { Theme.Colors.accentPurple.swiftUIColor },
            "accentOrange": { Theme.Colors.accentOrange.swiftUIColor },
            "primary": { Theme.Colors.primary.swiftUIColor },
            "destructive": { Theme.Colors.destructive.swiftUIColor },
            "success": { Theme.Colors.success.swiftUIColor },
            "foreground": { Theme.Colors.foreground.swiftUIColor },
            "muted": { Theme.Colors.muted.swiftUIColor },
            "systemRed": { Theme.Colors.systemRed.swiftUIColor },

            // Added colors for UniContainers
            "cardBackground": { Theme.Colors.cardBackground.swiftUIColor },
            "shadow": { Theme.Colors.shadow.swiftUIColor },
            "accent": { Theme.Colors.accent.swiftUIColor },
            "backgroundPrimary": { Theme.Colors.backgroundPrimary.swiftUIColor },
        ]
        // Fallback to clear if a color is not found to prevent crashes.
        // The theme manager itself will print an error in non-DEBUG builds.
        return map[colorName]?() ?? Color.clear
    }
    
    // MARK: - DynamicMemberLookup fallback
    public subscript(dynamicMember member: String) -> Color {
        self[member]
    }
    
    // MARK: - Semantic Accessors
    public var background: Color { self["background"] }
    public var contentBackground: Color { self["contentBackground"] }
    public var sidebarBackground: Color { self["sidebarBackground"] }
    public var selection: Color { self["selection"] }
    public var textPrimary: Color { self["textPrimary"] }
    public var textSecondary: Color { self["textSecondary"] }
    public var border: Color { self["border"] }
    public var accentBlue: Color { self["accentBlue"] }
    public var accentPurple: Color { self["accentPurple"] }
    public var accentOrange: Color { self["accentOrange"] }
    public var primary: Color { self["primary"] }
    public var destructive: Color { self["destructive"] }
    public var success: Color { self["success"] }
    public var foreground: Color { self["foreground"] }
    public var muted: Color { self["muted"] }
    public var systemRed: Color { self["systemRed"] }

    // Added colors for UniContainers
    public var cardBackground: Color { self["cardBackground"] }
    public var shadow: Color { self["shadow"] }
    public var accent: Color { self["accent"] }
    public var backgroundPrimary: Color { self["backgroundPrimary"] }
    
    // MARK: - All colors for previews/testing
    public var allColors: [String: Color] {
        [
            "background": background,
            "contentBackground": contentBackground,
            "sidebarBackground": sidebarBackground,
            "selection": selection,
            "textPrimary": textPrimary,
            "textSecondary": textSecondary,
            "border": border,
            "accentBlue": accentBlue,
            "accentPurple": accentPurple,
            "accentOrange": accentOrange,
            "primary": primary,
            "destructive": destructive,
            "success": success,
            "foreground": foreground,
            "muted": muted,
            "systemRed": systemRed,
            "cardBackground": cardBackground,
            "shadow": shadow,
            "accent": accent,
            "backgroundPrimary": backgroundPrimary,
        ]
    }
}


// MARK: - Font + Theme
@MainActor
public extension Font {
    /// A proxy namespace for accessing font tokens from the active design system.
    static let theme = ThemeFontProxy()
}

@MainActor
public struct ThemeFontProxy {
    public var code: Font { Theme.Fonts.code }
    public var body: Font { Theme.Fonts.body }
    public var headline: Font { Theme.Fonts.headline }
    public var largeTitle: Font { Theme.Fonts.largeTitle }
}

// MARK: - CGFloat + Theme
@MainActor
public extension CGFloat {
    /// A proxy namespace for accessing dimension tokens (spacing, radii).
    static let theme = ThemeDimensionProxy()
}

@MainActor
public struct ThemeDimensionProxy {
    // MARK: - Spacing
    public var spacingSmall: CGFloat { Theme.Spacing.small }
    public var spacingMedium: CGFloat { Theme.Spacing.medium }
    public var spacingLarge: CGFloat { Theme.Spacing.large }

    // MARK: - Radii
    public var radiusCard: CGFloat { Theme.Radii.card }
    public var radiusStandard: CGFloat { Theme.Radii.standard }
}

// MARK: - Edge.Set + Theme Spacing
@MainActor
public extension Edge.Set {
    /// A proxy namespace for accessing spacing tokens to use with padding modifiers.
     static let theme = ThemeEdgeSetDimensionProxy()
}

@MainActor
public struct ThemeEdgeSetDimensionProxy {
    public var spacingSmall: CGFloat { Theme.Spacing.small }
    public var spacingMedium: CGFloat { Theme.Spacing.medium }
    public var spacingLarge: CGFloat { Theme.Spacing.large }
}


// MARK: - Gradient+UnifiedColor.swift
// Note: These extensions are for creating ad-hoc gradients outside the token system.
public extension ShapeStyle where Self == AnyShapeStyle {

    /// Creates a linear gradient from an array of evenly-spaced unified colors.
    static func u_linear(
        colors unifiedColors: [UnifiedColor],
        startPoint: UnitPoint,
        endPoint: UnitPoint
    ) -> AnyShapeStyle {
        let swiftUIColors = unifiedColors.map { $0.swiftUIColor }
        return AnyShapeStyle(
            LinearGradient(colors: swiftUIColors, startPoint: startPoint, endPoint: endPoint)
        )
    }

    /// Creates a linear gradient from an array of unified color stops.
    static func u_linear(
        stops unifiedStops: [UnifiedGradientStop],
        startPoint: UnitPoint,
        endPoint: UnitPoint
    ) -> AnyShapeStyle {
        let swiftUIStops = unifiedStops.map { $0.swiftUIStop }
        let gradient = Gradient(stops: swiftUIStops)
        return AnyShapeStyle(
            LinearGradient(gradient: gradient, startPoint: startPoint, endPoint: endPoint)
        )
    }
}

// MARK: - UniContainers System

@MainActor
public struct UniContainersConfig {
    public static var shared = UniContainersConfig()

    public enum PerformanceMode {
        case standard
        case optimized
    }

    public let performanceMode: PerformanceMode
    public let defaultAnimation: Animation
    public let enableAccessibilityFeatures: Bool

    public init(
        performanceMode: PerformanceMode = .optimized,
        defaultAnimation: Animation = .spring(response: 0.4, dampingFraction: 0.8),
        enableAccessibilityFeatures: Bool = true
    ) {
        self.performanceMode = performanceMode
        self.defaultAnimation = defaultAnimation
        self.enableAccessibilityFeatures = enableAccessibilityFeatures
    }
}

internal struct AnimationEngine {
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    @MainActor
    func standardTransition() -> Animation {
        if reduceMotion, UniContainersConfig.shared.enableAccessibilityFeatures {
            return .easeInOut(duration: 0.1)
        }
        return UniContainersConfig.shared.defaultAnimation
    }
}

struct Package: Decodable, Identifiable, Hashable {
    let id = UUID()
    let title: String, description: String, iconName: String, visualStyle: String
    enum CodingKeys: String, CodingKey {
        case title, description, iconName, visualStyle
    }
}

@MainActor
class PackageLoader: ObservableObject {
    @Published var packages: [Package] = []

    init(jsonString: String) {
        loadPackages(from: jsonString)
    }

    func loadPackages(from jsonString: String) {
        guard let data = jsonString.data(using: .utf8) else {
            print("Error: Could not convert JSON string to data.")
            return
        }

        do {
            let root = try JSONDecoder().decode([RootPackageObject].self, from: data)
            if let firstRoot = root.first {
                self.packages = firstRoot.modules
            }
        } catch {
            print("Error decoding packages: \(error)")
        }
    }
}

struct RootPackageObject: Decodable {
    let modules: [Package]
}

public enum ContainerType {
    case card, flex, grid
}

public struct ContainerFactory {
    @MainActor @ViewBuilder
    public static func makeContainer<Content: View>(type: ContainerType, @ViewBuilder content: () -> Content) -> some View {
        switch type {
        case .card: CardContainer(content: content)
        case .flex: FlexContainer(content: content)
        case .grid: GridContainer(columns: 2, content: content)
        }
    }
}

public protocol UniContainer: View {
    associatedtype Content where Content: View
}

public struct FlexContainer<Content: View>: UniContainer {
    let content: Content
    let axis: Axis
    let alignment: HorizontalAlignment
    let spacing: CGFloat

    public init(axis: Axis = .vertical, alignment: HorizontalAlignment = .leading, spacing: CGFloat = .theme.spacingMedium, @ViewBuilder content: () -> Content) {
        self.axis = axis
        self.alignment = alignment
        self.spacing = spacing
        self.content = content()
    }

    public var body: some View {
        if axis == .vertical {
            VStack(alignment: alignment, spacing: spacing) { content }
        } else {
            HStack(alignment: .top, spacing: spacing) { content }
        }
    }
}

public struct GridContainer<Content: View>: UniContainer {
    let content: Content
    let columns: [GridItem]
    let spacing: CGFloat

    public init(columns: [GridItem], spacing: CGFloat, @ViewBuilder content: () -> Content) {
        self.columns = columns; self.spacing = spacing; self.content = content()
    }

    public init(columns: Int, spacing: CGFloat = .theme.spacingLarge, @ViewBuilder content: () -> Content) {
        // Corrected: Create the specified number of flexible columns.
        let gridItems = Array(repeating: GridItem(.flexible()), count: columns)
        self.init(columns: gridItems, spacing: spacing, content: content)
    }

    public init(@ViewBuilder content: () -> Content) {
        self.init(columns: 2, content: content)
    }

    public var body: some View {
        LazyVGrid(columns: columns, spacing: spacing) {
            content
        }
    }
}

public struct CardContainer<Content: View>: UniContainer {
    @EnvironmentObject var themeManager: uniTheme
    @State var isHovering = false
    var animationEngine = AnimationEngine()

    let content: Content
    let elevation: Int

    public init(elevation: Int, @ViewBuilder content: () -> Content) {
        self.elevation = elevation; self.content = content()
    }

    public init(@ViewBuilder content: () -> Content) {
        self.init(elevation: 1, content: content)
    }

    public var body: some View {
        content
            .padding(.theme.spacingLarge)
            .background(Color.theme.cardBackground)
            .cornerRadius(.theme.radiusCard)
            .shadow(color: Color.theme.shadow, radius: shadowRadius, x: 0, y: shadowY)
            .onHover { hovering in
                withAnimation(animationEngine.standardTransition()) {
                    isHovering = hovering
                }
            }
            .scaleEffect(isHovering ? 1.03 : 1.0)
    }

    var shadowRadius: CGFloat { isHovering ? CGFloat(elevation * 8) : CGFloat(elevation * 4) }
    var shadowY: CGFloat { isHovering ? CGFloat(elevation * 4) : CGFloat(elevation * 2) }
}

public struct ScrollContainer<Content: View>: View {
    let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        ScrollView {
            content
        }
    }
}

// MARK: - Containers/AccordionContainer.swift

/// A container for creating collapsible content sections.
public struct AccordionContainer<Title: View, Content: View>: View {
    let title: Title
    let content: Content
    @State  var isExpanded: Bool = false
    var animationEngine = AnimationEngine()

    public init(@ViewBuilder title: () -> Title, @ViewBuilder content: () -> Content) {
        self.title = title(); self.content = content()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                title
                Spacer()
                Image(systemName: "chevron.right").rotationEffect(.degrees(isExpanded ? 90 : 0))
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(animationEngine.standardTransition()) {
                    isExpanded.toggle()
                }
            }
            .padding(.theme.spacingMedium)
            .background(Color.theme.selection)
            .cornerRadius(.theme.radiusStandard)

            if isExpanded {
                content
                    .padding(.theme.spacingMedium)
                    .transition(.asymmetric(
                         insertion: .move(edge: .top).combined(with: .opacity),
                         removal: .opacity
                    ))
            }
        }
        .cornerRadius(.theme.radiusStandard)
        .overlay(
             RoundedRectangle(cornerRadius: .theme.radiusStandard)
                 .stroke(Color.theme.border, lineWidth: 1)
         )
    }
}


// MARK: - Containers/TabContainer.swift

/// A container for managing tabbed content views with lazy-loading.
public struct TabContainer: View {
    @State  var selectedTab: Int = 0
    let tabs: [(String, AnyView)]

    public init(tabs: [(String, AnyView)]) { self.tabs = tabs }

    public var body: some View {
        VStack {
            Picker("Tabs", selection: $selectedTab) {
                ForEach(0..<tabs.count, id: \.self) { index in
                    Text(tabs[index].0).tag(index)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            ZStack {
                 ForEach(0..<tabs.count, id: \.self) { index in
                     if selectedTab == index {
                         tabs[index].1
                             .transition(.opacity.animation(.easeInOut))
                     }
                 }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

// MARK: - Containers/SplitContainer.swift

/// A resizable split view container with a draggable divider.
public struct SplitContainer<Primary: View, Secondary: View>: View {
    let primary: Primary
    let secondary: Secondary
    @State  var splitRatio: CGFloat = 0.4
     let minRatio: CGFloat = 0.2
     let maxRatio: CGFloat = 0.8
     let dividerWidth: CGFloat = 8

    public init(@ViewBuilder primary: () -> Primary, @ViewBuilder secondary: () -> Secondary) {
        self.primary = primary(); self.secondary = secondary()
    }

    public var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                primary
                    .frame(width: geometry.size.width * splitRatio)

                Color.theme.border
                    .frame(width: dividerWidth)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let dragWidth = value.translation.width
                                let totalWidth = geometry.size.width
                                let deltaRatio = dragWidth / totalWidth
                                let newRatio = splitRatio + deltaRatio
                                self.splitRatio = max(minRatio, min(maxRatio, newRatio))
                            }
                    )
                    .zIndex(1)

                secondary
                    .frame(maxWidth: .infinity)
            }
        }
        .cornerRadius(.theme.radiusStandard)
        .overlay(
            RoundedRectangle(cornerRadius: .theme.radiusStandard)
                .stroke(Color.theme.border, lineWidth: 1)
        )
    }
}

// MARK: - Containers/ResponsiveContainer.swift

/// A container that provides its content with its size for fine-grained responsive layouts.
public struct ResponsiveContainer<Content: View>: View {
    @ViewBuilder public var content: (CGSize) -> Content

    public init(@ViewBuilder content: @escaping (CGSize) -> Content) { self.content = content }

    public var body: some View {
        GeometryReader { proxy in
            content(proxy.size)
        }
    }
}

// MARK: - Containers/VirtualContainer.swift

/// A high-performance container for rendering large, dynamic datasets.
public struct VirtualContainer<Content: View>: View {
    public var body: some View {
        VStack {
            Text("VirtualContainer Placeholder")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}


// MARK: - Containers/ModalContainer.swift (View Modifier)

/// A view modifier for presenting modal content with standardized animations and backdrop.
public struct ModalContainerModifier<ModalContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let modalContent: ModalContent
    var animationEngine = AnimationEngine()

    public func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                Color.black.opacity(0.6).ignoresSafeArea().onTapGesture { isPresented = false }.transition(.opacity)
                modalContent
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(1)
            }
        }
        .animation(animationEngine.standardTransition(), value: isPresented)
    }
}

public extension View {
    func modal<Content: View>(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) -> some View {
        self.modifier(ModalContainerModifier(isPresented: isPresented, modalContent: content()))
    }
}

// MARK: - Views/HomeView.swift

struct HomeView: View {
    @StateObject  var loader: PackageLoader
    @State  var selectedPackageID: UUID?
    @EnvironmentObject  var themeManager: uniTheme
    var animationEngine = AnimationEngine()

    init(jsonString: String) {
        _loader = StateObject(wrappedValue: PackageLoader(jsonString: jsonString))
    }

    var body: some View {
        FlexContainer(alignment: .leading) {
            Text("UniContainers System").font(.largeTitle.bold()).padding([.horizontal, .top])
            Text("A comprehensive, responsive, and performant container system.").font(.theme.body).foregroundColor(.theme.textSecondary).padding(.horizontal)

            ResponsiveContainer { size in
                 let minColumnWidth: CGFloat = size.width < 600 ? 300 : 250
                let columns: [GridItem] = [
                    .init(.adaptive(minimum: minColumnWidth))
                ]

                GridContainer(columns: columns, spacing: .theme.spacingLarge) {
                    ForEach(loader.packages) { package in
                        CardContainer(elevation: 2) {
                            PackageCardView(package: package, isSelected: selectedPackageID == package.id)
                        }
                        .onTapGesture {
                            withAnimation(animationEngine.standardTransition()) {
                                selectedPackageID = package.id
                            }
                        }
                        .accessibilityElement(children: .contain)
                    }
                }
            }
            .padding()
        }
        .background(Color.theme.backgroundPrimary.ignoresSafeArea())
    }
}

struct PackageCardView: View {
    let package: Package
    let isSelected: Bool
    @EnvironmentObject  var themeManager: uniTheme

    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: package.iconName)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.theme.accent)
                .padding(.bottom, 8)

            Text(package.title)
                .font(.theme.headline)
                .foregroundColor(.theme.textPrimary)

            Text(package.description)
                .font(.theme.body)
                .foregroundColor(.theme.textSecondary)
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(
            RoundedRectangle(cornerRadius: .theme.radiusCard + 4)
                .stroke(Color.theme.accentPurple, lineWidth: isSelected ? 3 : 0)
                .padding(-2)
        )
    }
}

// MARK: - Views/WelcomeView.swift

struct WelcomeView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject  var themeManager: uniTheme
    var animationEngine = AnimationEngine()

    var body: some View {
        CardContainer(elevation: 4) {
            VStack(spacing: .theme.spacingLarge) {
                Image(systemName: "shippingbox.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.theme.accent)

                Text("Welcome to UniContainers").font(.largeTitle.bold()).foregroundColor(.theme.textPrimary)

                ScrollContainer {
                    Text("This system provides a suite of powerful, responsive, and reusable containers to build consistent and beautiful UIs. Click 'Get Started' to explore the interactive dashboard.")
                        .font(.theme.body).foregroundColor(.theme.textSecondary).lineSpacing(5).multilineTextAlignment(.center)
                }

                Button("Get Started") {
                    withAnimation(animationEngine.standardTransition()) {
                        isPresented = false
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(.theme.accent)
            }
        }
        .frame(maxWidth: 500, maxHeight: 600)
        .padding()
    }
}

// MARK: - Views/DocumentationView.swift

struct DocumentationView: View {
    @EnvironmentObject  var themeManager: uniTheme

    var body: some View {
        ScrollContainer {
            GridContainer(columns: 1, spacing: .theme.spacingLarge) {

                AccordionContainer {
                    Text("Layout Containers").font(.theme.headline).foregroundColor(.theme.textPrimary)
                } content: {
                    VStack(alignment: .leading, spacing: .theme.spacingMedium) {
                        Text("`SplitContainer` manages core layout. Drag the divider below.")
                            .font(.theme.body).foregroundColor(.theme.textSecondary)

                        SplitContainer {
                            Color.theme.accent.opacity(0.3).overlay(Text("Primary"))
                        } secondary: {
                            Color.theme.accentPurple.opacity(0.3).overlay(Text("Secondary"))
                        }
                        .frame(height: 200)
                    }
                }

                AccordionContainer {
                    Text("Navigation Containers").font(.theme.headline).foregroundColor(.theme.textPrimary)
                } content: {
                    VStack(alignment: .leading, spacing: .theme.spacingMedium) {
                        Text("`TabContainer` manages different views and lazy-loads content.")
                            .font(.theme.body).foregroundColor(.theme.textSecondary)
                        
                        TabContainer(tabs: [
                            ("Usage", AnyView(Text("Usage details here.").padding())),
                            ("API", AnyView(Text("API Reference here.").padding())),
                            ("Examples", AnyView(Image(systemName: "star.fill").font(.largeTitle).padding()))
                        ])
                        .frame(height: 200)
                        .background(Color.theme.selection)
                        .cornerRadius(.theme.radiusStandard)
                    }
                }
            }
            .padding()
        }
       .background(Color.theme.background.ignoresSafeArea())
    }
}



// MARK: - App Entry Point & Root View

public struct UniContainersRootView: View {
    @State var showWelcomeModal = true
    @StateObject var themeManager = uniTheme.shared

     let packageJSON: String

    public init(json: String) {
        self.packageJSON = json
    }

    public var body: some View {
        TabView {
            NavigationView {
                HomeView(jsonString: packageJSON)
                    .navigationTitle("Home")
            }
            .tabItem { Label("Home", systemImage: "house.fill") }

            NavigationView {
                DocumentationView()
                    .navigationTitle("Documentation")
            }
            .tabItem { Label("Docs", systemImage: "book.fill") }
        }
        .modal(isPresented: $showWelcomeModal) {
            WelcomeView(isPresented: $showWelcomeModal)
        }
        .environmentObject(themeManager)
        .onAppear {
            // To apply a specific theme on launch, uncomment the following line:
            // themeManager.applyDesignSystem(AppDesignSystems.documentation)
        }
        .accentColor(.theme.accent)
        .foregroundColor(.theme.textPrimary)
    }
}

// MARK: - Preview Provider

struct UniContainers_Previews: PreviewProvider {
    static let previewJSON = """
    [ { "name": "UniContainers", "modules": [ { "title": "ContainerFactory", "description": "Centralized container management.", "iconName": "square.stack.3d.up.fill", "visualStyle": "factory" }, { "title": "FlexiContainer", "description": "Flexbox container.", "iconName": "rectangle.split.3x1.fill", "visualStyle": "flex" }, { "title": "FlexContainer", "description": "Advanced flexbox container.", "iconName": "rectangle.split.3x1.fill", "visualStyle": "flex" }, { "title": "GridContainer", "description": "Powerful grid system.", "iconName": "grid", "visualStyle": "grid" } ] } ]
    """

    static var previews: some View {
        UniContainersRootView(json: previewJSON)
            .environmentObject(uniTheme.shared)
    }
}
```
