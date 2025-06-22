//
//  ScrollBehaviorToken.swift
//  uniColor
//
//  Created by garyrobertellis on 6/21/25.
//


import SwiftUI

public enum ScrollBehaviorToken {
    /// Standard scroll behavior.
    case standard
    /// Bounces more elastically at the edges.
    case elastic
    /// Allows certain views to "stick" to the top during scroll.
    case stickyHeader
}

// You would then upgrade ScrollContainer to use these:
public struct UpgradedScrollContainer<Content: View>: View {
    let behavior: ScrollBehaviorToken
    let content: Content
    
    public init(behavior: ScrollBehaviorToken = .standard, @ViewBuilder content: () -> Content) {
        self.behavior = behavior
        self.content = content()
    }
    
    public var body: some View {
        ScrollView {
            content
        }
        // In iOS 17+, you can use .scrollBounceBehavior()
        // For sticky headers, you would use a GeometryReader to track scroll position.
        .if(behavior == .elastic) { view in
            // Apply bounce behavior modifier if available
            view
        }
    }
}