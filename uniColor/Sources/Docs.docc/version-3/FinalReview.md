# Sensory Core - Refactored Project Structure

This document outlines the complete, refactored file structure for the Sensory Core design system. The code has been broken down into modular files, each under 100 lines, and organized into a logical directory hierarchy.

---
## 📁 1_Tokens
*This directory contains the fundamental building blocks of the design system.*

---
### File: `1_Tokens/UnifiedColor.swift`
```swift
import SwiftUI

/// A platform-agnostic, immutable struct representing a color in the sRGB space.
/// It is the foundation of the entire color system.
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
    
    /// A computed property to easily convert to a SwiftUI Color.
    public var swiftUIColor: Color {
        Color(red: red, green: green, blue: blue, opacity: alpha)
    }

    /// Returns a new instance of the color with a modified alpha component.
    public func withOpacity(_ newAlpha: Double) -> UnifiedColor {
        UnifiedColor(red: self.red, green: self.green, blue: self.blue, alpha: newAlpha)
    }
}

File: 1_Tokens/UnifiedColor+Hex.swift

import Foundation

// Hexadecimal string initializer for UnifiedColor.
public extension UnifiedColor {
    init(hex: String) {
        let hexStr = hex.trimmingCharacters(in: .whitespacesAndNewlines).dropFirst(hex.hasPrefix("#") ? 1 : 0)
        var hexValue: UInt64 = 0
        guard Scanner(string: String(hexStr)).scanHexInt64(&hexValue) else {
            self.init(red: 0, green: 0, blue: 0); return
        }

        let r, g, b, a: Double
        switch hexStr.count {
        case 3: // RGB
            r = Double((hexValue & 0xF00) >> 8) / 15.0
            g = Double((hexValue & 0x0F0) >> 4) / 15.0
            b = Double(hexValue & 0x00F) / 15.0
            a = 1.0
        case 6: // RRGGBB
            r = Double((hexValue & 0xFF0000) >> 16) / 255.0
            g = Double((hexValue & 0x00FF00) >> 8) / 255.0
            b = Double(hexValue & 0x0000FF) / 255.0
            a = 1.0
        case 8: // RRGGBBAA
            r = Double((hexValue & 0xFF000000) >> 24) / 255.0
            g = Double((hexValue & 0x00FF0000) >> 16) / 255.0
            b = Double((hexValue & 0x0000FF00) >> 8) / 255.0
            a = Double(hexValue & 0x000000FF) / 255.0
        default:
            (r, g, b, a) = (0, 0, 0, 1)
        }
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}

File: 1_Tokens/DesignToken.swift

import SwiftUI

/// A type-erased container for any fundamental design system value.
public enum DesignToken: Hashable {
    case staticColor(UnifiedColor)
    case spacing(CGFloat)
    case radius(CGFloat)
}

File: 1_Tokens/TokenKey.swift

import Foundation

/// A type-safe key for retrieving a `DesignToken` from a `DesignSystem`.
/// This prevents magic strings and provides compile-time safety.
public struct TokenKey: Hashable, CustomStringConvertible {
    public let group: String
    public let name: String

    public init(group: String, name: String) {
        self.group = group
        self.name = name
    }

    public var description: String {
        "\(group).\(name)"
    }
}

File: 1_Tokens/DesignSystem.swift

import SwiftUI

/// A struct representing a complete design system. It contains collections
/// of design tokens that together define a visual theme.
public struct DesignSystem: Identifiable {
    public var id: String { name }
    public let name: String
    
    // Dictionaries to hold the core values of the theme.
    let tokens: [TokenKey: DesignToken]
    let fonts: [TokenKey: Font] // Fonts are not Hashable and are stored separately.

    public init(name: String, tokens: [TokenKey: DesignToken], fonts: [TokenKey: Font]) {
        self.name = name
        self.tokens = tokens
        self.fonts = fonts
    }

    /// Safely retrieves a generic token for a given key.
    internal func token(for key: TokenKey) -> DesignToken? {
        tokens[key]
    }

    /// Safely retrieves a font for a given key.
    internal func font(for key: TokenKey) -> Font? {
        fonts[key]
    }
}

File: 1_Tokens/AppDesignSystems.swift

import SwiftUI

/// A namespace that defines all concrete `DesignSystem` instances
/// available within the application.
@MainActor
public enum AppDesignSystems {
    /// The primary, light-themed design system.
    public static let `default` = DesignSystem(
        name: "Default",
        tokens: defaultTokens,
        fonts: defaultFonts
    )

    /// A darker, more dramatic design system.
    public static let documentation = DesignSystem(
        name: "Documentation",
        tokens: documentationTokens,
        fonts: documentationFonts
    )
    
    /// An array containing all available design systems for easy access.
    public static let all: [DesignSystem] = [`default`, documentation]
}

File: 1_Tokens/DefaultTheme.swift

import SwiftUI

// This file defines the tokens for the "Default" theme.
@MainActor
internal let defaultColors: [TokenKey: UnifiedColor] = [
    TokenKey(group: "color", name: "primary"): UnifiedColor(hex: "#0A84FF"),
    TokenKey(group: "color", name: "destructive"): UnifiedColor(hex: "#FF3B30"),
    TokenKey(group: "color", name: "success"): UnifiedColor(hex: "#34C759"),
    TokenKey(group: "color", name: "warning"): UnifiedColor(hex: "#FF9500"),
    TokenKey(group: "color", name: "background"): UnifiedColor(hex: "#F9F9F9"),
    TokenKey(group: "color", name: "backgroundSecondary"): UnifiedColor(hex: "#F2F2F7"),
    TokenKey(group: "color", name: "textPrimary"): UnifiedColor(hex: "#1C1C1E"),
    TokenKey(group: "color", name: "textSecondary"): UnifiedColor(hex: "#636366"),
    TokenKey(group: "color", name: "muted"): UnifiedColor(hex: "#8E8E93"),
    TokenKey(group: "color", name: "border"): UnifiedColor(hex: "#D1D1D6"),
]

@MainActor
internal var defaultTokens: [TokenKey: DesignToken] = defaultColors.mapValues { .staticColor($0) }
    .merging([
        TokenKey(group: "spacing", name: "small"): .spacing(4),
        TokenKey(group: "spacing", name: "medium"): .spacing(8),
        TokenKey(group: "spacing", name: "large"): .spacing(16),
        TokenKey(group: "radius", name: "standard"): .radius(10),
        TokenKey(group: "radius", name: "card"): .radius(20),
    ], uniquingKeysWith: { (first, _) in first })

@MainActor
internal let defaultFonts: [TokenKey: Font] = [
    TokenKey(group: "font", name: "body"): .body,
    TokenKey(group: "font", name: "headline"): .headline,
    TokenKey(group: "font", name: "largeTitle"): .largeTitle,
    TokenKey(group: "font", name: "monospace"): .system(.body, design: .monospaced)
]

File: 1_Tokens/DocumentationTheme.swift

import SwiftUI

// This file defines the tokens for the "Documentation" theme.
@MainActor
internal let documentationColors: [TokenKey: UnifiedColor] = [
    TokenKey(group: "color", name: "primary"): UnifiedColor(hex: "#BF5AF2"),
    TokenKey(group: "color", name: "destructive"): UnifiedColor(hex: "#FF453A"),
    TokenKey(group: "color", name: "success"): UnifiedColor(hex: "#32D74B"),
    TokenKey(group: "color", name: "warning"): UnifiedColor(hex: "#FFD60A"),
    TokenKey(group: "color", name: "background"): UnifiedColor(hex: "#1D1D1F"),
    TokenKey(group: "color", name: "backgroundSecondary"): UnifiedColor(hex: "#2C2C2E"),
    TokenKey(group: "color", name: "textPrimary"): UnifiedColor(hex: "#FFFFFF"),
    TokenKey(group: "color", name: "textSecondary"): UnifiedColor(hex: "#E5E5EA"),
    TokenKey(group: "color", name: "muted"): UnifiedColor(hex: "#8E8E93"),
    TokenKey(group: "color", name: "border"): UnifiedColor(hex: "#48484A"),
]

@MainActor
internal var documentationTokens: [TokenKey: DesignToken] = documentationColors.mapValues { .staticColor($0) }
    .merging([
        TokenKey(group: "spacing", name: "small"): .spacing(5),
        TokenKey(group: "spacing", name: "medium"): .spacing(10),
        TokenKey(group: "spacing", name: "large"): .spacing(20),
        TokenKey(group: "radius", name: "standard"): .radius(12),
        TokenKey(group: "radius", name: "card"): .radius(24),
    ], uniquingKeysWith: { (first, _) in first })

@MainActor
internal let documentationFonts: [TokenKey: Font] = [
    TokenKey(group: "font", name: "body"): .system(.body, design: .rounded),
    TokenKey(group: "font", name: "headline"): .system(.headline, design: .rounded).weight(.bold),
    TokenKey(group: "font", name: "largeTitle"): .system(.largeTitle, design: .rounded).weight(.heavy),
    TokenKey(group: "font", name: "monospace"): .system(.body, design: .monospaced)
]

📁 2_Engine
This directory contains the core logic that powers the theming system.

File: 2_Engine/UniTheme.swift

import SwiftUI
import Combine

/// A singleton `ObservableObject` responsible for managing the application's
/// active design system and persisting the user's choice.
@MainActor
public final class uniTheme: ObservableObject {
    public static let shared = uniTheme()
    static let themeKey = "com.sensorycore.selectedTheme"

    @Published public var currentDesignSystem: DesignSystem

    public let availableDesignSystems: [DesignSystem] = AppDesignSystems.all

    private init() {
        let savedName = UserDefaults.standard.string(forKey: Self.themeKey)
        self.currentDesignSystem = availableDesignSystems.first { $0.name == savedName }
            ?? AppDesignSystems.default
    }

    /// Applies a new design system to the application and saves the choice.
    public func applyDesignSystem(named name: String) {
        guard let system = availableDesignSystems.first(where: { $0.name == name }) else {
            return
        }
        currentDesignSystem = system
        UserDefaults.standard.set(system.name, forKey: Self.themeKey)
    }
}

File: 2_Engine/Theme.swift

import SwiftUI

/// Provides idiomatic, type-safe access to the active design system's tokens.
/// This acts as the primary API for developers to use themed values in their views.
///
/// Usage:
/// ```
/// Color.theme.primary
/// Font.theme.headline
/// CGFloat.themeSpacing.medium
/// ```
@MainActor
public enum Theme {
    internal static var manager: uniTheme { uniTheme.shared }

    private static func token(for key: TokenKey) -> DesignToken? {
        manager.currentDesignSystem.token(for: key)
    }
    
    private static func font(for key: TokenKey) -> Font {
        manager.currentDesignSystem.font(for: key) ?? .body
    }

    /// A proxy namespace for all color tokens.
    public enum Colors {
        public static var primary: UnifiedColor { color(named: "primary") }
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

File: 2_Engine/Theme+Extensions.swift

import SwiftUI

// This file provides the syntactic sugar extensions that make using the
// Theme API so convenient and idiomatic in SwiftUI.

// MARK: - Spacing, Radii, Fonts Proxies
public extension Theme {
    /// A proxy namespace for all spacing tokens.
    enum Spacing {
        public static var small: CGFloat { spacing(named: "small") }
        public static var medium: CGFloat { spacing(named: "medium") }
        public static var large: CGFloat { spacing(named: "large") }
        
        private static func spacing(named name: String) -> CGFloat {
            let key = TokenKey(group: "spacing", name: name)
            guard case .spacing(let value) = token(for: key) else { return 0 }
            return value
        }
    }
    
    /// A proxy namespace for all radius tokens.
    enum Radii {
        public static var standard: CGFloat { radius(named: "standard") }
        public static var card: CGFloat { radius(named: "card") }
        
        private static func radius(named name: String) -> CGFloat {
            let key = TokenKey(group: "radius", name: name)
            guard case .radius(let value) = token(for: key) else { return 0 }
            return value
        }
    }
    
    /// A proxy namespace for all font tokens.
    enum Fonts {
        public static var body: Font { font(for: .init(group: "font", name: "body")) }
        public static var headline: Font { font(for: .init(group: "font", name: "headline")) }
        public static var largeTitle: Font { font(for: .init(group: "font", name: "largeTitle")) }
        public static var monospace: Font { font(for: .init(group: "font", name: "monospace")) }
    }
}

// MARK: - Type Extensions for API Access
public extension Color { static var theme: Theme.Colors.Type { Theme.Colors.self } }
public extension CGFloat { static var themeSpacing: Theme.Spacing.Type { Theme.Spacing.self } }
public extension CGFloat { static var themeRadius: Theme.Radii.Type { Theme.Radii.self } }
public extension Font { static var theme: Theme.Fonts.Type { Theme.Fonts.self } }

File: 2_Engine/OneState.swift

import Foundation

/// Represents the universal interaction and feedback states for any
/// stateful UI component within the Sensory Core system.
public enum OneState: CaseIterable, Hashable {
    /// The default, interactive state.
    case normal
    /// The state when a pointer is hovering over the component.
    case hover
    /// The state when the component is actively being pressed.
    case pressed
    /// The state when the component is non-interactive.
    case disabled
    /// The state when the component has keyboard or remote focus.
    case focused
    /// The state when the component is performing a background task.
    case loading
    /// The state after a successful action.
    case success
    /// The state after a failed action.
    case error
}

File: 2_Engine/OneAnimation.swift

import SwiftUI

/// A proxy namespace for accessing a central registry of theme-defined,
/// named animations. This ensures consistent motion design across the app.
public extension Animation {
    static let one = OneAnimationProxy()
}

public struct OneAnimationProxy {
    /// A bouncy, springy pop for interactive feedback.
    public var springPop: Animation {
        .spring(response: 0.4, dampingFraction: 0.7)
    }

    /// A smooth animation for expanding and collapsing container views.
    public var expandCollapse: Animation {
        .spring(response: 0.45, dampingFraction: 0.85)
    }

    /// A quick, subtle fade for elements appearing or disappearing.
    public var fadeInOut: Animation {
        .easeInOut(duration: 0.2)
    }
}

File: 2_Engine/OneEffect.swift

import SwiftUI

/// A declarative API for applying a suite of reusable visual effects.
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
public enum OneEffect {
    case shadow(color: Color, radius: CGFloat, y: CGFloat)
    case glow(color: Color, radius: CGFloat)
    case glass
}

File: 2_Engine/EffectModifiers.swift

import SwiftUI

/// Applies a standard, theme-aware shadow effect.
public struct ShadowEffect: ViewModifier {
    let color: Color
    let radius: CGFloat
    let y: CGFloat
    
    public func body(content: Content) -> some View {
        content.shadow(color: color, radius: radius, y: y)
    }
}

/// Applies a soft, glowing aura effect, often used for focus or emphasis.
public struct GlowEffect: ViewModifier {
    let color: Color
    let radius: CGFloat

    public func body(content: Content) -> some View {
        // A simple glow is often achieved by layering multiple soft shadows.
        content
            .shadow(color: color, radius: radius / 2, y: 0)
            .shadow(color: color, radius: radius, y: 0)
    }
}

/// Applies a translucent, frosted-glass material background.
public struct GlassEffect: ViewModifier {
    public func body(content: Content) -> some View {
        if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
            content.background(.ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: .themeRadius.card, style: .continuous)
            )
        } else {
            // Fallback for older OS versions
            content.background(
                Color.theme.backgroundSecondary.swiftUIColor.opacity(0.85)
            )
        }
    }
}

📁 3_Components
This directory contains the reusable, theme-aware UI components.

File: 3_Components/Primitives/OneButton.swift

import SwiftUI

/// The flagship interactive button for the Sensory Core system. It is fully
/// state-aware and uses themed tokens for all its visual properties.
public struct OneButton: View {
    let title: String
    @Binding var state: OneState
    let action: () -> Void

    @State private var isHovering = false
    @State private var isPressed = false

    public var body: some View {
        Button(action: {
            if state == .normal { action() }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: .themeRadius.standard)
                    .fill(backgroundColor.swiftUIColor)
                    .oneEffect(shadow)
                
                buttonContent
            }
        }
        .buttonStyle(.plain)
        .disabled(state != .normal)
        .scaleEffect(scale)
        .onHover { hovering in if state != .disabled { isHovering = hovering } }
        .pressEvents(onPress: { if state != .disabled { isPressed = true } },
                     onRelease: { isPressed = false })
        .animation(.one.springPop, value: scale)
        .animation(.one.fadeInOut, value: state)
        .animation(.one.fadeInOut, value: currentDerivedState)
    }
    
    @ViewBuilder
    private var buttonContent: some View {
        HStack(spacing: .themeSpacing.medium) {
            if state == .loading {
                ProgressView()
            } else {
                Text(title)
                    .font(.theme.headline)
                    .fontWeight(.bold)
            }
        }
        .padding(.horizontal, .themeSpacing.large)
        .padding(.vertical, .themeSpacing.medium)
        .foregroundStyle(foregroundColor.swiftUIColor)
    }
}

File: 3_Components/Primitives/OneButton+State.swift

import SwiftUI

// This extension separates the state-derivation logic from the main
// `OneButton` view definition, improving code organization.
internal extension OneButton {
    
    /// Derives the true visual state by combining the external `state` binding
    /// with internal interaction states like hover and press.
    var currentDerivedState: OneState {
        // External state always takes precedence.
        if state != .normal { return state }
        
        // Internal interaction states are used only when the button is normal.
        if isPressed { return .pressed }
        if isHovering { return .hover }
        
        return .normal
    }

    var backgroundColor: UnifiedColor {
        switch currentDerivedState {
        case .disabled: return .theme.muted
        case .pressed: return .theme.primary.withOpacity(0.8)
        case .success: return .theme.success
        case .error: return .theme.destructive
        default: return .theme.primary
        }
    }

    var foregroundColor: UnifiedColor {
        // For now, text is always white for contrast on colored backgrounds.
        .init(red: 1, green: 1, blue: 1)
    }
    
    var scale: CGFloat {
        (currentDerivedState == .pressed) ? 0.96 : (isHovering ? 1.04 : 1.0)
    }
    
    var shadow: OneEffect? {
        if currentDerivedState == .disabled { return nil }
        let color = Color.black.opacity(0.25)
        let radius: CGFloat = isPressed ? 4 : (isHovering ? 16 : 8)
        let y: CGFloat = isPressed ? 2 : (isHovering ? 8 : 4)
        return .shadow(color: color, radius: radius, y: y)
    }
}

File: 3_Components/Primitives/OneIcon.swift

import SwiftUI

/// A universal, theme-aware icon component that can display SF Symbols.
public struct OneIcon: View {
    let systemName: String
    var size: CGFloat = 32

    public var body: some View {
        Image(systemName: systemName)
            .font(.system(size: size, weight: .medium))
            .foregroundStyle(Color.theme.textPrimary.swiftUIColor)
    }
}

File: 3_Components/Primitives/OneText.swift

import SwiftUI

/// A theme-aware text component that simplifies applying typographic tokens.
public struct OneText: View {
    let text: String
    let style: Font
    let color: UnifiedColor

    public init(_ text: String, style: Font = .theme.body, color: UnifiedColor = .theme.textPrimary) {
        self.text = text
        self.style = style
        self.color = color
    }

    public var body: some View {
        Text(text)
            .font(style)
            .foregroundStyle(color.swiftUIColor)
    }
}

File: 3_Components/Primitives/OneBadge.swift

import SwiftUI

/// A small, theme-aware badge, often used for counters or status indicators.
public struct OneBadge: View {
    let text: String
    let color: UnifiedColor

    public init(_ text: String, color: UnifiedColor = .theme.primary) {
        self.text = text
        self.color = color
    }

    public var body: some View {
        Text(text)
            .font(.caption.weight(.bold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.swiftUIColor)
            .foregroundStyle(Color.white)
            .clipShape(Capsule())
    }
}

File: 3_Components/Cards/HeroCard.swift

import SwiftUI

/// A large, prominent card style for showcasing hero content. It features
/// significant padding and a noticeable shadow.
public struct HeroCard<Content: View>: View {
    @ViewBuilder let content: Content
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: .themeRadius.card)
                .fill(Color.theme.backgroundSecondary.swiftUIColor)
                .oneEffect(.shadow(color: .black.opacity(0.1), radius: 20, y: 10))
            
            content
                .padding(.themeSpacing.large * 2)
        }
    }
}

File: 3_Components/Cards/ModuleCard.swift

import SwiftUI

/// A standard card for containing a module of content. It features a subtle
/// border and standard padding.
public struct ModuleCard<Content: View>: View {
    @ViewBuilder let content: Content
    
    public var body: some View {
        content
            .padding(.themeSpacing.large)
            .background(Color.theme.backgroundSecondary.swiftUIColor)
            .cornerRadius(.themeRadius.card)
            .overlay(
                RoundedRectangle(cornerRadius: .themeRadius.card)
                    .stroke(Color.theme.border.swiftUIColor, lineWidth: 1)
            )
    }
}

File: 3_Components/Cards/RowCard.swift

import SwiftUI

/// A card optimized for horizontal content, such as an item in a list.
/// It has less padding and a standard corner radius.
public struct RowCard<Content: View>: View {
    @ViewBuilder let content: Content
    
    public var body: some View {
        HStack {
            content
            Spacer()
        }
        .padding()
        .background(Color.theme.backgroundSecondary.swiftUIColor)
        .cornerRadius(.themeRadius.standard)
    }
}

File: 3_Components/Cards/FeaturedCard.swift

import SwiftUI

/// A vibrant, eye-catching card that uses a gradient and glow effect
/// to draw attention to featured content.
public struct FeaturedCard<Content: View>: View {
    let gradient: Gradient
    @ViewBuilder let content: Content
    
    public var body: some View {
        ZStack {
            let fill = LinearGradient(
                gradient: gradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            RoundedRectangle(cornerRadius: .themeRadius.card).fill(fill)
                .oneEffect(.glow(
                    color: gradient.stops.first?.color ?? .accentColor, radius: 30)
                )
            
            content
                .padding(.themeSpacing.large)
        }
    }
}

File: 3_Components/Cards/LandingCard.swift

import SwiftUI

/// A card specifically designed for landing pages, often containing an
/// icon, title, and subtitle to introduce a feature.
public struct LandingCard: View {
    let iconName: String
    let title: String
    let subtitle: String

    public var body: some View {
        ModuleCard {
            VStack(spacing: .themeSpacing.medium) {
                OneIcon(systemName: iconName, size: 40)
                    .foregroundStyle(Color.theme.primary.swiftUIColor)
                
                OneText(title, style: .theme.headline)
                
                OneText(subtitle, style: .theme.body, color: .theme.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

File: 3_Components/AppIcons/IOSAppIcon.swift

import SwiftUI

/// A representation of the app icon designed for iOS, following
/// standard super-ellipse conventions.
public struct IOSAppIcon: View {
    public var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.white
                RoundedRectangle(cornerRadius: geo.size.width * 0.22)
                    .fill(Color.theme.primary.swiftUIColor.gradient)
                    .frame(width: geo.size.width * 0.6, height: geo.size.width * 0.6)
                Circle()
                    .stroke(Color.white, lineWidth: geo.size.width * 0.05)
                    .frame(width: geo.size.width * 0.25)
            }
            .clipShape(RoundedRectangle(cornerRadius: geo.size.width * 0.22, style: .continuous))
        }
    }
}

File: 3_Components/AppIcons/MacOSAppIcon.swift

import SwiftUI

/// A representation of the app icon for macOS, typically featuring
/// a squircle shape with a slight shadow or depth.
public struct MacOSAppIcon: View {
    public var body: some View {
        GeometryReader { geo in
            ZStack {
                RoundedRectangle(cornerRadius: geo.size.width * 0.18, style: .continuous)
                    .fill(Color.theme.backgroundSecondary.swiftUIColor)
                    .shadow(radius: 2, y: 1)
                
                IOSAppIcon()
                    .scaleEffect(0.8)
            }
        }
    }
}

File: 3_Components/AppIcons/WatchOSAppIcon.swift

import SwiftUI

/// A representation of the app icon for watchOS, which is always circular.
public struct WatchOSAppIcon: View {
    public var body: some View {
        GeometryReader { geo in
            ZStack {
                Circle().fill(Color.black)
                
                Circle()
                    .trim(from: 0.2, to: 1.0)
                    .stroke(
                        Color.theme.primary.swiftUIColor,
                        style: StrokeStyle(lineWidth: geo.size.width * 0.1, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-180))
                    .frame(width: geo.size.width * 0.65)
            }
        }
    }
}

File: 3_Components/AppIcons/TVOSAppIcon.swift

import SwiftUI

/// A representation of the app icon for tvOS. It's layered and can
/// produce parallax effects when focused.
public struct TVOSAppIcon: View {
    public var body: some View {
        ZStack {
            // The back layer moves less.
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.theme.primary.swiftUIColor.opacity(0.5))
                .shadow(radius: 10)
            
            // The front layer moves more.
            Image(systemName: "wand.and.stars")
                .font(.system(size: 80))
                .foregroundStyle(.white)
        }
        .frame(width: 400, height: 240)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

File: 3_Components/AppIcons/VisionOSAppIcon.swift

import SwiftUI

#if canImport(RealityKit)
import RealityKit

/// A representation of the app icon for visionOS, designed for a 3D,
/// spatial context. It may be volumetric.
public struct VisionOSAppIcon: View {
    public var body: some View {
        ZStack {
            // A subtle glass background.
            Circle().fill(.white.opacity(0.1))
            
            // A 3D-like shape using gradients and shadows.
            Circle()
                .fill(Color.theme.primary.swiftUIColor)
                .shadow(color: .black.opacity(0.4), radius: 20, x: 0, y: 10)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.5), lineWidth: 2)
                        .blur(radius: 2)
                )
                .padding(20)
        }
        .oneEffect(.glass)
        .clipShape(Circle())
    }
}
#endif

📁 4_Platform
This directory contains platform-specific abstractions and modifiers.

File: 4_Platform/PrimaryAction.swift

import SwiftUI

/// A ViewModifier that attaches the correct gesture for a primary user action,
/// making components platform-agnostic (tap vs. click vs. remote press).
public struct PrimaryActionModifier: ViewModifier {
    var action: () -> Void
    public func body(content: Content) -> some View {
        #if os(tvOS)
        // On tvOS, the primary action is the remote's select button.
        Button(action: action) { content }.buttonStyle(.card)
        #else
        // On other platforms, it's a direct tap or click.
        content.onTapGesture(perform: action)
        #endif
    }
}

public extension View {
    /// Applies a platform-aware primary action trigger to the view.
    func onPrimaryAction(perform action: @escaping () -> Void) -> some View {
        self.modifier(PrimaryActionModifier(action: action))
    }
}

File: 4_Platform/PressEvents.swift

import SwiftUI

// A generic press event handler that works across platforms by using a DragGesture.
public extension View {
    func pressEvents(
        onPress: @escaping (() -> Void),
        onRelease: @escaping (() -> Void)
    ) -> some View {
        self.gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in onPress() }
                .onEnded { _ in onRelease() }
        )
    }
}

File: 4_Platform/FocusAware.swift

import SwiftUI

#if os(tvOS)
/// A ViewModifier that applies visual effects when a view gains or loses
/// focus on tvOS, essential for remote-based navigation.
public struct FocusAwareModifier: ViewModifier {
    @FocusState private var isFocused: Bool
    
    public func body(content: Content) -> some View {
        content
            .focusable()
            .focused($isFocused)
            .oneEffect(isFocused ? .glow(color: .white, radius: 20) : .none)
            .scaleEffect(isFocused ? 1.1 : 1.0)
            .animation(.one.springPop, value: isFocused)
    }
}

public extension View {
    /// Makes a view visually responsive to focus changes on tvOS.
    func focusAware() -> some View {
        self.modifier(FocusAwareModifier())
    }
}
#endif

File: 4_Platform/PageTransitionStyle.swift

import SwiftUI

/// Defines a set of named transitions for page-level navigation,
/// promoting a consistent narrative feel.
public enum PageTransitionStyle {
    case fade
    case slide
    case scaleUp
    
    @MainActor
    var anyTransition: AnyTransition {
        switch self {
        case .fade:
            return .opacity.animation(.one.fadeInOut)
        case .slide:
            return .asymmetric(
                insertion: .move(edge: .trailing),
                removal: .move(edge: .leading)
            ).animation(.one.expandCollapse)
        case .scaleUp:
            return .scale(scale: 0.95).combined(with: .opacity)
                .animation(.one.springPop)
        }
    }
}

File: 4_Platform/ConditionalModifiers.swift

import SwiftUI

// Helper extension for applying modifiers conditionally.
public extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

📁 5_App
This directory contains high-level views, demos, and the app's main entry point.

File: 5_App/Views/OnboardingView.swift

import SwiftUI

/// The main view for the onboarding flow, using a TabView to present pages.
public struct OnboardingView: View {
    @Binding var isPresented: Bool
    
    public var body: some View {
        VStack(spacing: 0) {
            TabView {
                OnboardingPage(
                    imageName: "sparkles.tv.fill",
                    title: "Welcome to Sensory Core",
                    subtitle: "A unified system for building beautiful, multi-platform interfaces."
                )
                OnboardingPage(
                    imageName: "switch.2",
                    title: "Dynamic Theming",
                    subtitle: "Switch between entire design systems with a single tap. Try it in Settings!"
                )
                OnboardingPage(
                    imageName: "hand.tap.fill",
                    title: "Ready to Go",
                    subtitle: "You're all set. Let's start building something amazing together."
                )
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            
            OneButton(title: "Get Started", state: .constant(.normal)) {
                isPresented = false
            }
            .padding()
        }
        .background(Color.theme.background.swiftUIColor.ignoresSafeArea())
        .foregroundStyle(Color.theme.textPrimary.swiftUIColor)
    }
}

File: 5_App/Views/OnboardingPage.swift

import SwiftUI

/// A single, reusable page view for the onboarding sequence.
struct OnboardingPage: View {
    let imageName: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: imageName)
                .font(.system(size: 80))
                .foregroundStyle(Color.theme.primary.swiftUIColor)
                .oneEffect(.glow(color: .theme.primary.swiftUIColor, radius: 40))
            
            Text(title)
                .font(.theme.largeTitle)
                .fontWeight(.bold)
            
            Text(subtitle)
                .font(.theme.headline)
                .foregroundStyle(Color.theme.textSecondary.swiftUIColor)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Spacer()
            Spacer()
        }
        .padding()
    }
}

File: 5_App/Views/HomeView.swift

import SwiftUI

/// The main landing view of the application.
public struct HomeView: View {
    public var body: some View {
        ScrollView {
            VStack(spacing: .themeSpacing.large) {
                HeroCard {
                    VStack {
                        OneText("Sensory Core", style: .system(size: 50, weight: .heavy, design: .rounded))
                        OneText("The Unified Interface System", style: .theme.headline, color: .theme.textSecondary)
                    }
                }
                
                FeaturedCard(gradient: Gradient(colors: [.purple, .blue])) {
                    HStack {
                        OneIcon(systemName: "wand.and.stars")
                        OneText("Fully Implemented & Refactored", style: .theme.headline)
                    }
                    .foregroundStyle(.white)
                }
                
                LandingCard(iconName: "switch.2", title: "Dynamic Theming", subtitle: "Change themes on the fly from the Settings tab.")
                
                LandingCard(iconName: "square.stack.3d.up.fill", title: "Component Library", subtitle: "Explore all available components in the Gallery.")
            }
            .padding()
        }
        .background(Color.theme.background.swiftUIColor.ignoresSafeArea())
        .navigationTitle("Home")
    }
}

File: 5_App/Views/ComponentGalleryView.swift

import SwiftUI

/// A view that displays a gallery of all core components for testing and review.
public struct ComponentGalleryView: View {
    @State private var buttonState: OneState = .normal
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                gallerySection(title: "Buttons") {
                    OneButton(title: "Run Action", state: $buttonState) {
                        buttonState = .loading
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            buttonState = .success
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                buttonState = .normal
                            }
                        }
                    }
                }
                
                gallerySection(title: "Badges") {
                    HStack {
                        OneBadge("Default")
                        OneBadge("Success", color: .theme.success)
                        OneBadge("Warning", color: .theme.warning)
                        OneBadge("Error", color: .theme.destructive)
                    }
                }
                
                gallerySection(title: "App Icons") {
                    HStack(spacing: 20) {
                        IOSAppIcon().frame(width: 60, height: 60)
                        MacOSAppIcon().frame(width: 60, height: 60)
                        WatchOSAppIcon().frame(width: 60, height: 60)
                    }
                }
            }
            .padding()
        }
        .background(Color.theme.background.swiftUIColor.ignoresSafeArea())
        .navigationTitle("Component Gallery")
    }
    
    @ViewBuilder
    private func gallerySection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: .themeSpacing.medium) {
            OneText(title, style: .theme.largeTitle, color: .theme.textPrimary)
            ModuleCard {
                content()
            }
        }
    }
}

File: 5_App/Views/SettingsView.swift

import SwiftUI

/// A simple settings view, primarily for changing the active theme.
public struct SettingsView: View {
    @EnvironmentObject private var themeManager: uniTheme

    public var body: some View {
        Form {
            Section("Appearance") {
                Picker("Theme", selection: .init(
                    get: { themeManager.currentDesignSystem.name },
                    set: { themeManager.applyDesignSystem(named: $0) }
                )) {
                    ForEach(themeManager.availableDesignSystems) { system in
                        Text(system.name).tag(system.name)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
        .navigationTitle("Settings")
    }
}

File: 5_App/Demos/SensoryCoreiOSApp.swift

import SwiftUI

// The main entry point for the iOS application.
// @main
struct SensoryCoreiOSApp: App {
    @StateObject private var themeManager = uniTheme.shared
    @State private var showOnboarding = true
    
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationView { HomeView() }
                    .tabItem { Label("Home", systemImage: "house.fill") }
                
                NavigationView { ComponentGalleryView() }
                    .tabItem { Label("Gallery", systemImage: "square.grid.2x2.fill") }

                NavigationView { SettingsView() }
                    .tabItem { Label("Settings", systemImage: "gear") }
            }
            .environmentObject(themeManager)
            .sheet(isPresented: $showOnboarding) {
                OnboardingView(isPresented: $showOnboarding)
            }
        }
    }
}

File: 5_App/Demos/SensoryCoreMacOSApp.swift

import SwiftUI

// The main entry point for the macOS application.
// @main
struct SensoryCoreMacOSApp: App {
    @StateObject private var themeManager = uniTheme.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationSplitView {
                List {
                    NavigationLink("Home", destination: HomeView())
                    NavigationLink("Gallery", destination: ComponentGalleryView())
                }
                .listStyle(.sidebar)
                .navigationTitle("Sensory Core")
            } detail: {
                ComponentGalleryView()
            }
            .environmentObject(themeManager)
            .onAppear {
                // Default to the darker theme for the macOS app.
                themeManager.applyDesignSystem(named: "Documentation")
            }
        }
        .windowStyle(.hiddenTitleBar)
        
        Settings {
            // Provide a standard macOS settings window.
            SettingsView()
                .padding()
                .frame(width: 400, height: 200)
                .environmentObject(themeManager)
        }
    }
}

File: 5_App/Demos/CardDemoView.swift

import SwiftUI

/// A view specifically for demonstrating the different card components.
struct CardDemoView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                HeroCard {
                    OneText("Hero Card", style: .theme.largeTitle)
                }
                
                FeaturedCard(gradient: Gradient(colors: [.pink, .orange])) {
                    HStack {
                        OneIcon(systemName: "star.fill", size: 24)
                        OneText("Featured Card", style: .theme.headline)
                    }.foregroundStyle(.white)
                }
                
                ModuleCard {
                    OneText("This is a standard Module Card, perfect for containing sections of content.", style: .theme.body)
                }
                
                RowCard {
                    OneIcon(systemName: "checkmark.seal.fill", size: 20)
                    OneText("Row Card for list items", style: .theme.body)
                }
                
                LandingCard(iconName: "leaf.fill", title: "Landing Card", subtitle: "Introduce a key feature or idea.")
            }.padding()
        }
        .navigationTitle("Card Demo")
        .background(Color.theme.background.swiftUIColor)
    }
}

File: 5_App/Demos/EffectDemoView.swift

import SwiftUI

/// A view for demonstrating the `OneEffect` modifiers.
struct EffectDemoView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                effectRow(title: "Glass Effect")
                    .oneEffect(.glass)
                
                effectRow(title: "Glow Effect")
                    .oneEffect(.glow(color: .theme.primary.swiftUIColor, radius: 25))
                
                effectRow(title: "Shadow Effect")
                    .oneEffect(.shadow(color: .black.opacity(0.2), radius: 10, y: 5))
            }
            .padding(30)
        }
        .navigationTitle("Effect Demo")
        .background(Color.theme.background.swiftUIColor.ignoresSafeArea())
    }
    
    private func effectRow(title: String) -> some View {
        OneText(title, style: .theme.headline)
            .padding(25)
            .frame(maxWidth: .infinity)
            .background(Color.theme.backgroundSecondary.swiftUIColor)
            .cornerRadius(.themeRadius.standard)
    }
}


// File: 5_App/Demos/FullAppPreview.swift

import SwiftUI

// This file provides convenient previews for the entire application experience.
#if DEBUG
struct SensoryCore_iOS_Preview: PreviewProvider {
    static var previews: some View {
        SensoryCoreiOSApp().body
    }
}

struct SensoryCore_macOS_Preview: PreviewProvider {
    static var previews: some View {
        SensoryCoreMacOSApp().body
            .frame(width: 900, height: 600)
    }
}
#endif

