//
//  InputDevice.swift
//  uniColor
//
//  Created by garyrobertellis on 6/21/25.
//


import SwiftUI

/// Identifies the primary input mechanism of the current platform.
public enum InputDevice {
    case touch // iOS, iPadOS
    case pointer // macOS
    case remote // tvOS
    case gesture // visionOS
}

/// A ViewModifier that attaches the correct gesture or trigger for a primary user action,
/// making components platform-agnostic.
public struct PrimaryActionModifier: ViewModifier {
    var action: () -> Void

    public func body(content: Content) -> some View {
        #if os(tvOS)
        // On tvOS, the primary action is handled by the focus system's select event.
        // We make the content focusable and the Button handles the action.
        Button(action: action) {
            content
        }
        .buttonStyle(.card) // Use the tvOS card style for a native feel
        #elseif os(visionOS)
        // On visionOS, the primary action is an indirect pinch gesture.
        content.onTapGesture(perform: action)
        #else
        // On iOS and macOS, it's a direct tap or click.
        content.onTapGesture(perform: action)
        #endif
    }
}

public extension View {
    /// Applies a platform-aware primary action trigger to the view.
    /// - Parameter action: The closure to execute when the primary action is triggered.
    func onPrimaryAction(perform action: @escaping () -> Void) -> some View {
        self.modifier(PrimaryActionModifier(action: action))
    }
}