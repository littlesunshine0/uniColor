//
//  PageTransitionStyle.swift
//  uniColor
//
//  Created by garyrobertellis on 6/21/25.
//


import SwiftUI

/// Defines a set of named transitions for page-level navigation.
public enum PageTransitionStyle {
    case fade
    case slide
    case stack
    case scaleUp
    case depth // For visionOS
    
    /// Maps the enum case to a concrete SwiftUI transition.
    @MainActor
    var anyTransition: AnyTransition {
        switch self {
        case .fade:
            return .opacity
        case .slide:
            return .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
        case .stack:
            return .asymmetric(insertion: .move(edge: .trailing), removal: .identity)
        case .scaleUp:
            return .scale.combined(with: .opacity)
        case .depth:
            // Placeholder for a custom RealityKit-powered transition
            return .identity
        }
    }
}