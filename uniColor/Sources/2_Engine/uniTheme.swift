import SwiftUI
import Combine

/// A singleton `ObservableObject` responsible for managing the application's
/// active design system. It holds the `currentDesignSystem`, publishes changes to
/// the UI, and persists the user's theme choice to `UserDefaults`.
@MainActor
public final class uniTheme: ObservableObject {
    public static let shared = uniTheme()
    static let themeKey = "com.sensorycore.selectedTheme"

    @Published public var currentDesignSystem: DesignSystem

    public let availableDesignSystems: [DesignSystem] = AppDesignSystems.all

    private init() {
        let savedName = UserDefaults.standard.string(forKey: Self.themeKey)
        // Load the saved theme or fall back to the default.
        self.currentDesignSystem = availableDesignSystems.first { $0.name == savedName }
            ?? AppDesignSystems.default
    }

    /// Applies a new design system to the application and saves the choice.
    /// This is the central mechanism for live theme-switching.
    public func applyDesignSystem(named name: String) {
        guard let system = availableDesignSystems.first(where: { $0.name == name }) else {
            print("Warning: Design system with name '\(name)' not found.")
            return
        }
        currentDesignSystem = system
        UserDefaults.standard.set(system.name, forKey: Self.themeKey)
    }
}
