//
//  OneAnimationProxy.swift
//  uniColor
//
//  Created by garyrobertellis on 6/21/25.
//


import SwiftUI

/// A proxy namespace for accessing theme-defined animations.
public extension Animation {
    @MainActor static let one = OneAnimationProxy()
}

public struct OneAnimationProxy {
    /// A quick, subtle fade for elements appearing/disappearing.
    public var fadeInOut: Animation {
        .easeInOut(duration: 0.2)
    }
    
    /// A bouncy, springy pop for emphasis.
    public var springPop: Animation {
        .spring(response: 0.4, dampingFraction: 0.7, blendDuration: 0)
    }
    
    /// A shimmering animation for loading states.
    public var shimmer: Animation {
        .easeInOut(duration: 1.5).repeatForever(autoreverses: false)
    }
    
    /// A transition for expanding/collapsing containers like `AccordionContainer`.
    public var expandCollapse: Animation {
        .spring(response: 0.45, dampingFraction: 0.85)
    }

    /// Provides a custom animation or falls back to a default.
    public func custom(
        duration: Double = 0.3,
        curve: Animation = .easeInOut
    ) -> Animation {
        curve.speed(1.0 / duration) // A simple way to parameterize
    }
}
