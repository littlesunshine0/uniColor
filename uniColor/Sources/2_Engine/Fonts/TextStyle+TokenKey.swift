import SwiftUI

// Maps SwiftUI's semantic `Font.TextStyle` to our project's `TokenKey`.
// This allows the `FontProvider` to look up the correct `FontDescription`
// when a developer requests a standard style like `.headline` or `.body`.
internal extension Font.TextStyle {
    var tokenKey: TokenKey {
        switch self {
        case .largeTitle:
            return TokenKey(group: "font", name: "largeTitle")
        case .headline:
            return TokenKey(group: "font", name: "headline")
        case .body:
            return TokenKey(group: "font", name: "body")
        case .caption, .caption2:
            return TokenKey(group: "font", name: "caption")
        case .callout:
             return TokenKey(group: "font", name: "body")
        case .footnote:
             return TokenKey(group: "font", name: "caption")
        // Add other cases as needed
        default:
            return TokenKey(group: "font", name: "body")
        }
    }
}
