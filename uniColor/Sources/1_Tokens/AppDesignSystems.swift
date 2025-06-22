import SwiftUI

/// A namespace that defines all concrete `DesignSystem` instances
/// available within the application. This serves as the central registry
/// from which the `uniTheme` manager draws.
@MainActor
public enum AppDesignSystems {
    /// The primary, light-themed design system, often used as the default.
    /// It features high contrast and standard spacing.
    public static let `default` = DesignSystem(
        name: "Default",
        tokens: defaultTokens,
        fonts: defaultFontDescriptions
    )

    /// A darker, more dramatic design system, suitable for media-focused apps
    /// or low-light environments. It uses a different spacing scale and font treatment.
    public static let documentation = DesignSystem(
        name: "Documentation",
        tokens: documentationTokens,
        fonts: documentationFontDescriptions
    )
    
    /// An array containing all available design systems for easy access,
    /// for example, in a theme selection UI.
    public static let all: [DesignSystem] = [`default`, documentation]
}
