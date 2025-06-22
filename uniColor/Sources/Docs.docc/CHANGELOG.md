# Changelog: v3.0.0 - Catalyst

This release marks a fundamental evolution of the library, officially rebranding to **`uniColor`** and graduating from a color utility to a comprehensive Design System Engine.

### 🚨 BREAKING CHANGES 🚨

*   **API Redesign:** The `Theme` and `ColorPalette` structs have been **removed** and replaced by the more powerful `DesignSystem` and `DesignToken` models.
*   **`ThemeManager` Overhaul:** The `ThemeManager`'s API has changed. It no longer manages `.currentTheme` but now manages `.currentDesignSystem`. The methods for applying themes have been updated accordingly.
*   **Token Access:** Accessing theme values is now done via type-safe methods on `ThemeManager` (e.g., `ThemeManager.shared.color(name: "background")`) instead of direct property access on a palette.

### ✨ New Features

*   **Design Token System:**
    *   Introduced `DesignToken`, an enum that can represent colors, fonts, spacing, and radii.
    *   Introduced `TokenKey` for type-safe, string-based retrieval of tokens.
*   **`DesignSystem` Model:** A new top-level struct that acts as a registry for a complete collection of design tokens, forming a single source of truth for a theme.
*   **Upgraded `ThemeManager`:**
    *   Now a fully-fledged design system engine.
    *   Provides type-safe accessors like `.color(name:)`, `.font(name:)`, and `.dimension(group:name:)` that `fatalError` if a token is missing or of the wrong type, ensuring immediate feedback during development.
*   **Official Rebranding:** The package name, product name, and all related artifacts are now standardized under the `uniColor` brand.

### 🐛 Bug Fixes & Refinements

*   This version incorporates the critical bug fix for `UIColor` conversion and the fluent `.withOpacity()` modifier from the previous development cycle.
*   The `Package` model used in examples was corrected to conform to `Equatable` instead of `Hashable` to resolve compilation errors.