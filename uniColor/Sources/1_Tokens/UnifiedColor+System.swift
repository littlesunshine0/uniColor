//
//  SystemColorType.swift
//  uniColor
//
//  Created by garyrobertellis on 6/16/25.
//
/*

// MARK: - UnifiedColor+System.swift

import SwiftUI
#if canImport(UIKit)
import UIKit
private typealias PColor = UIColor
#elseif canImport(AppKit)
import AppKit
private typealias PColor = NSColor
#else
private typealias PColor = Any
#endif

public enum SystemColorType: CaseIterable {
    case primarySystemBackground, secondarySystemBackground, tertiarySystemBackground,
         primarySystemGroupedBackground, secondarySystemGroupedBackground, tertiarySystemGroupedBackground,
         label, secondaryLabel, tertiaryLabel, quaternaryLabel, placeholderText,
         systemFill, secondarySystemFill, tertiarySystemFill, quaternarySystemFill
}

public extension UnifiedColor {
    init?(systemColor: SystemColorType) {
        #if os(iOS) || os(tvOS)
        let platformColor = Self.platformColor(for: systemColor)
        guard let color = platformColor else { return nil }
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        guard color.getRed(&r, green: &g, blue: &b, alpha: &a) else { return nil }
        self.init(red: Double(r), green: Double(g), blue: Double(b), alpha: Double(a))
        #elseif os(macOS)
        let platformColor = Self.platformColor(for: systemColor)
        guard let color = platformColor, let srgbColor = color.usingColorSpace(.sRGB) else { return nil }
        self.init(red: Double(srgbColor.redComponent), green: Double(srgbColor.greenComponent), blue: Double(srgbColor.blueComponent), alpha: Double(srgbColor.alphaComponent))
        #else
        return nil
        #endif
    }

    private static func platformColor(for systemColor: SystemColorType) -> PColor? {
        #if os(iOS) || os(tvOS)
        switch systemColor {
        case .primarySystemBackground: return .systemBackground; case .secondarySystemBackground: return .secondarySystemBackground; case .tertiarySystemBackground: return .tertiarySystemBackground; case .primarySystemGroupedBackground: return .systemGroupedBackground; case .secondarySystemGroupedBackground: return .secondarySystemGroupedBackground; case .tertiarySystemGroupedBackground: return .tertiarySystemGroupedBackground; case .label: return .label; case .secondaryLabel: return .secondaryLabel; case .tertiaryLabel: return .tertiaryLabel; case .quaternaryLabel: return .quaternaryLabel; case .placeholderText: return .placeholderText; case .systemFill: return .systemFill; case .secondarySystemFill: return .secondarySystemFill; case .tertiarySystemFill: return .tertiarySystemFill; case .quaternarySystemFill: return .quaternarySystemFill
        }
        #elseif os(macOS)
        switch systemColor {
        case .primarySystemBackground: return .windowBackgroundColor; case .secondarySystemBackground: return .underPageBackgroundColor; case .tertiarySystemBackground: return .controlBackgroundColor; case .primarySystemGroupedBackground: return .windowBackgroundColor; case .secondarySystemGroupedBackground: return .controlBackgroundColor; case .tertiarySystemGroupedBackground: return .underPageBackgroundColor; case .label: return .labelColor; case .secondaryLabel: return .secondaryLabelColor; case .tertiaryLabel: return .tertiaryLabelColor; case .quaternaryLabel: return .quaternaryLabelColor; case .placeholderText: return .placeholderTextColor; case .systemFill: return .controlColor; case .secondarySystemFill: return .windowBackgroundColor; case .tertiarySystemFill: return .unemphasizedSelectedContentBackgroundColor; case .quaternarySystemFill: return .separatorColor
        }
        #else
        return nil
        #endif
    }
}

public extension UnifiedColor {
    private static func resolve(_ type: SystemColorType, fallback: @autoclosure () -> UnifiedColor) -> UnifiedColor {
        if let color = UnifiedColor(systemColor: type) { return color }
        else {
            #if DEBUG
            fatalError("SystemColorType '\(type)' failed to resolve. Using fallback.")
            #else
            return fallback()
            #endif
        }
    }
    static var primarySystemBackground: UnifiedColor { resolve(.primarySystemBackground, fallback: UnifiedColor(hex: "#FFFFFF")) }
    static var secondarySystemBackground: UnifiedColor { resolve(.secondarySystemBackground, fallback: UnifiedColor(hex: "#F2F2F7")) }
    static var tertiarySystemBackground: UnifiedColor { resolve(.tertiarySystemBackground, fallback: UnifiedColor(hex: "#FFFFFF")) }
    static var primarySystemGroupedBackground: UnifiedColor { resolve(.primarySystemGroupedBackground, fallback: UnifiedColor(hex: "#F2F2F7")) }
    static var secondarySystemGroupedBackground: UnifiedColor { resolve(.secondarySystemGroupedBackground, fallback: UnifiedColor(hex: "#FFFFFF")) }
    static var tertiarySystemGroupedBackground: UnifiedColor { resolve(.tertiarySystemGroupedBackground, fallback: UnifiedColor(hex: "#F2F2F7")) }
    static var label: UnifiedColor { resolve(.label, fallback: UnifiedColor(hex: "#000000")) }
    static var secondaryLabel: UnifiedColor { resolve(.secondaryLabel, fallback: UnifiedColor(hex: "#3C3C4399")) }
    static var tertiaryLabel: UnifiedColor { resolve(.tertiaryLabel, fallback: UnifiedColor(hex: "#3C3C434D")) }
    static var quaternaryLabel: UnifiedColor { resolve(.quaternaryLabel, fallback: UnifiedColor(hex: "#3C3C432E")) }
    static var placeholderText: UnifiedColor { resolve(.placeholderText, fallback: UnifiedColor(hex: "#3C3C434D")) }
    static var systemFill: UnifiedColor { resolve(.systemFill, fallback: UnifiedColor(hex: "#78788033")) }
    static var secondarySystemFill: UnifiedColor { resolve(.secondarySystemFill, fallback: UnifiedColor(hex: "#78788029")) }
    static var tertiarySystemFill: UnifiedColor { resolve(.tertiarySystemFill, fallback: UnifiedColor(hex: "#7676801F")) }
    static var quaternarySystemFill: UnifiedColor { resolve(.quaternarySystemFill, fallback: UnifiedColor(hex: "#74748014")) }
}
*/
