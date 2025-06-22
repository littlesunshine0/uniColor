import SwiftUI

#if os(tvOS)
/// A ViewModifier that applies visual effects when a view gains or loses
/// focus on tvOS. This is essential for creating a usable "10-foot experience"
/// where the user navigates with a remote and needs clear visual feedback.
public struct FocusAwareModifier: ViewModifier {
    @FocusState private var isFocused: Bool
    
    public func body(content: Content) -> some View {
        content
            .focusable()
            .focused($isFocused)
            .oneEffect(isFocused ? .glow(color: .white.opacity(0.7), radius: 25) : .none)
            .scaleEffect(isFocused ? 1.1 : 1.0)
            .animation(.one.springPop, value: isFocused)
    }
}

public extension View {
    /// Makes a view visually responsive to focus changes on tvOS.
    func focusAware() -> some View {
        self.modifier(FocusAwareModifier())
    }
}
#endif
