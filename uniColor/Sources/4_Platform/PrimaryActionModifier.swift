//
//  PrimaryActionModifier.swift
//  uniColor
//
//  Created by garyrobertellis on 6/22/25.
//


import SwiftUI

/// A ViewModifier that attaches the correct gesture for a primary user action,
/// making components platform-agnostic. This is a critical abstraction for
/// building truly universal components.
public struct PrimaryActionModifier: ViewModifier {
    var action: () -> Void
    public func body(content: Content) -> some View {
        #if os(tvOS)
        // On tvOS, the primary action is the remote's select button, which is
        // intrinsically handled by wrapping the content in a `Button`.
        Button(action: action) { content }.buttonStyle(.card)
        #else
        // On iOS, macOS, and visionOS, the primary action is a direct tap or click.
        content.onTapGesture(perform: action)
        #endif
    }
}

public extension View {
    /// Applies a platform-aware primary action trigger to the view.
    func onPrimaryAction(perform action: @escaping () -> Void) -> some View {
        self.modifier(PrimaryActionModifier(action: action))
    }
}
