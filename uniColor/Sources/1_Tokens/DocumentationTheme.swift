import SwiftUI

// This file defines the tokens for the "Documentation" (dark) theme.
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
        // A wider spacing scale for a more spacious feel
        TokenKey(group: "spacing", name: "xxsmall"): .spacing(3),
        TokenKey(group: "spacing", name: "xsmall"): .spacing(5),
        TokenKey(group: "spacing", name: "small"): .spacing(10),
        TokenKey(group: "spacing", name: "medium"): .spacing(20),
        TokenKey(group: "spacing", name: "large"): .spacing(40),
        TokenKey(group: "spacing", name: "xlarge"): .spacing(80),
        // Radii, Durations, and Assets
        TokenKey(group: "radius", name: "standard"): .radius(12),
        TokenKey(group: "radius", name: "card"): .radius(24),
        TokenKey(group: "duration", name: "short"): .timeInterval(0.25),
        TokenKey(group: "duration", name: "medium"): .timeInterval(0.5),
        TokenKey(group: "duration", name: "long"): .timeInterval(1.0),
        TokenKey(group: "asset", name: "logo"): .asset("logo-dark"),
    ], uniquingKeysWith: { (first, _) in first })

@MainActor
internal let documentationFontDescriptions: [TokenKey: FontDescription] = [
    TokenKey(group: "font", name: "body"): .init(family: .sjElite, size: 17, weight: .regular),
    TokenKey(group: "font", name: "body-italic"): .init(family: .sjElite, size: 17, weight: .regular, isItalic: true),
    TokenKey(group: "font", name: "headline"): .init(family: .sjElite, size: 28, weight: .bold),
    TokenKey(group: "font", name: "largeTitle"): .init(family: .sjElite, size: 34, weight: .heavy),
    TokenKey(group: "font", name: "monospace"): .init(family: .uniSJ, size: 16, weight: .regular),
    TokenKey(group: "font", name: "caption"): .init(family: .sjMini, size: 12, weight: .medium),
]
