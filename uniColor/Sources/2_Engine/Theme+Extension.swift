//
//  Spacing.swift
//  uniColor
//
//  Created by garyrobertellis on 6/21/25.
//


import SwiftUI

// This file provides the syntactic sugar extensions that make using the
// Theme API so convenient and idiomatic in SwiftUI. It defines the nested
// proxy enums for each token type.
// MARK: - Spacing, Radii, Fonts, Durations, Assets Proxies
public extension Theme {
    @MainActor
    enum Spacing {
        public static var xxsmall: CGFloat { value(named: "xxsmall", group: "spacing") }
        public static var xsmall: CGFloat { value(named: "xsmall", group: "spacing") }
        public static var small: CGFloat { value(named: "small", group: "spacing") }
        public static var medium: CGFloat { value(named: "medium", group: "spacing") }
        public static var large: CGFloat { value(named: "large", group: "spacing") }
        public static var xlarge: CGFloat { value(named: "xlarge", group: "spacing") }
    }
    @MainActor
    enum Radii {
        public static var standard: CGFloat { value(named: "standard", group: "radius") }
        public static var card: CGFloat { value(named: "card", group: "radius") }
    }
    @MainActor
    enum Durations {
        public static var short: TimeInterval { value(named: "short", group: "duration") }
        public static var medium: TimeInterval { value(named: "medium", group: "duration") }
        public static var long: TimeInterval { value(named: "long", group: "duration") }
    }
    @MainActor
    enum Assets {
        public static var logo: String { value(named: "logo", group: "asset") }
    }
    @MainActor
    enum Fonts {
        public static var body: Font { FontProvider.font(for: .body) }
        public static var bodyItalic: Font { FontProvider.font(for: .init(group: "font", name: "body-italic")) }
        public static var headline: Font { FontProvider.font(for: .headline) }
        public static var largeTitle: Font { FontProvider.font(for: .largeTitle) }
        public static var monospace: Font { FontProvider.font(for: .init(group: "font", name: "monospace")) }
        public static var caption: Font { FontProvider.font(for: .init(group: "font", name: "caption")) }

    }
}

// MARK: - Generic Token Value Resolvers
private extension Theme {
    static func value<T>(named name: String, group: String) -> T {
        let key = TokenKey(group: group, name: name)
        guard let token = token(for: key) else {
            #if DEBUG
            fatalError("Token '\(key)' not found.")
            #else
            if T.self is CGFloat.Type { return 0 as! T }
            if T.self is TimeInterval.Type { return 0 as! T }
            if T.self is String.Type { return "" as! T }
            fatalError("Unsupported token type for fallback.")
            #endif
        }
        
        switch (T.self, token) {
            case (is CGFloat.Type, .spacing(let val)): return val as! T
            case (is CGFloat.Type, .radius(let val)): return val as! T
            case (is TimeInterval.Type, .timeInterval(let val)): return val as! T
            case (is String.Type, .asset(let val)): return val as! T
            default:
            #if DEBUG
                fatalError("Token '\(key)' is of the wrong type.")
            #else
                if T.self is CGFloat.Type { return 0 as! T }
                if T.self is TimeInterval.Type { return 0 as! T }
                if T.self is String.Type { return "" as! T }
                fatalError("Unsupported token type for fallback.")
            #endif
        }
    }
}

// MARK: - Type Extensions for API Access
public extension Color { static var theme: Theme.Colors.Type { Theme.Colors.self } }
public extension CGFloat { static var themeSpacing: Theme.Spacing.Type { Theme.Spacing.self } }
public extension CGFloat { static var themeRadius: Theme.Radii.Type { Theme.Radii.self } }
public extension Font { static var theme: Theme.Fonts.Type { Theme.Fonts.self } }
public extension TimeInterval { static var theme: Theme.Durations.Type { Theme.Durations.self } }
public extension String { static var themeAsset: Theme.Assets.Type { Theme.Assets.self } }
