//
//  FocusAwareModifier.swift
//  uniColor
//
//  Created by garyrobertellis on 6/21/25.
//


import SwiftUI

#if os(tvOS)
/// A ViewModifier that applies visual effects to a view when it gains or loses focus on tvOS.
public struct FocusAwareModifier: ViewModifier {
    @FocusState private var isFocused: Bool
    
    public func body(content: Content) -> some View {
        content
            .focusable()
            .focused($isFocused)
            // Apply effects from our OneEffect library
            .oneEffect(isFocused ? .glow(color: .white, radius: 20) : .shadow(radius: 5, y: 5))
            .scaleEffect(isFocused ? 1.1 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

public extension View {
    /// Makes a view visually responsive to focus changes on tvOS.
    func focusAware() -> some View {
        self.modifier(FocusAwareModifier())
    }
}
#endif