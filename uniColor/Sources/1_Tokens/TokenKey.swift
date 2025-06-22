import Foundation

/// A type-safe key for retrieving a `DesignToken` from a `DesignSystem`.
/// This struct prevents the use of "magic strings" for token names, reducing
/// runtime errors and making the system easier to navigate and refactor.
/// A key is composed of a `group` (e.g., "color") and a `name` (e.g., "primary").
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
