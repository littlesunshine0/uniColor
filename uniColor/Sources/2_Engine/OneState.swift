//
//  OneState.swift
//  uniColor
//
//  Created by garyrobertellis on 6/21/25.
//


import Foundation

/// Represents the universal interaction and feedback states for any
/// stateful UI component within the Sensory Core system. This enum is the
/// cornerstone of creating predictable and consistent interactive elements.
public enum OneState: CaseIterable, Hashable {
    /// The default, interactive state, ready for user input.
    case normal
    /// The state when a pointer is hovering over the component (macOS, iPadOS).
    case hover
    /// The state when the component is actively being pressed or clicked.
    case pressed
    /// The state when the component is non-interactive, often visually dimmed.
    case disabled
    /// The state when the component has keyboard or remote focus.
    case focused
    /// The state when the component is performing a background task.
    case loading
    /// The state after a successful action, providing positive feedback.
    case success
    /// The state after a failed action, providing error feedback.
    case error
}

/// A protocol for any view that can be driven by the `OneState` enum.
public protocol OneStateful {
    /// The current state of the component.
    var state: OneState { get set }

    /// A method to handle state transitions, allowing for animations.
    /// In SwiftUI, this is often handled declaratively by observing state changes.
    func transition(to state: OneState, animated: Bool)
}
