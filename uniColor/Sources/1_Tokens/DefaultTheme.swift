import SwiftUI

// This file defines the tokens for the "Default" (light) theme.
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
        // A more granular spacing scale
        TokenKey(group: "spacing", name: "xxsmall"): .spacing(2),
        TokenKey(group: "spacing", name: "xsmall"): .spacing(4),
        TokenKey(group: "spacing", name: "small"): .spacing(8),
        TokenKey(group: "spacing", name: "medium"): .spacing(16),
        TokenKey(group: "spacing", name: "large"): .spacing(32),
        TokenKey(group: "spacing", name: "xlarge"): .spacing(64),
        // Radii, Durations, and Assets
        TokenKey(group: "radius", name: "standard"): .radius(10),
        TokenKey(group: "radius", name: "card"): .radius(20),
        TokenKey(group: "duration", name: "short"): .timeInterval(0.2),
        TokenKey(group: "duration", name: "medium"): .timeInterval(0.4),
        TokenKey(group: "duration", name: "long"): .timeInterval(0.8),
        TokenKey(group: "asset", name: "logo"): .asset("logo-light"),
    ], uniquingKeysWith: { (first, _) in first })

@MainActor
internal let defaultFontDescriptions: [TokenKey: FontDescription] = [
    TokenKey(group: "font", name: "body"): .init(family: .sjElite, size: 17, weight: .regular),
    TokenKey(group: "font", name: "body-italic"): .init(family: .sjElite, size: 17, weight: .regular, isItalic: true),
    TokenKey(group: "font", name: "headline"): .init(family: .sjElite, size: 28, weight: .bold),
    TokenKey(group: "font", name: "largeTitle"): .init(family: .sjElite, size: 34, weight: .heavy),
    TokenKey(group: "font", name: "monospace"): .init(family: .uniSJ, size: 16, weight: .regular),
    TokenKey(group: "font", name: "caption"): .init(family: .sjMini, size: 12, weight: .medium),
]
