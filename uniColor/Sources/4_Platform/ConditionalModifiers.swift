import SwiftUI

// A helper extension for applying modifiers conditionally. This is a common
// SwiftUI pattern that improves code readability by avoiding the need for
// `AnyView` type erasure or complex `if/else` blocks in the view body.
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
