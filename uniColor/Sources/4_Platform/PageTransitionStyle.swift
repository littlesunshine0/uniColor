import SwiftUI

/// Defines a set of named transitions for page-level navigation,
/// promoting a consistent and cinematic narrative feel. Using these tokens
/// ensures that transitions between views are coherent and themeable.
public enum PageTransitionStyle {
    case fade
    case slide
    case scaleUp
    
    @MainActor
    var anyTransition: AnyTransition {
        switch self {
        case .fade:
            return .opacity.animation(.one.fadeInOut())
        case .slide:
            return .asymmetric(
                insertion: .move(edge: .trailing),
                removal: .move(edge: .leading)
            ).animation(.one.expandCollapse)
        case .scaleUp:
            return .scale(scale: 0.95).combined(with: .opacity)
                .animation(.one.springPop)
        }
    }
}

