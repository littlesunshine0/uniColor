//
//  FeaturedCard.swift
//  uniColor
//
//  Created by garyrobertellis on 6/22/25.
//


import SwiftUI

/// A vibrant, eye-catching card that uses a gradient and glow effect
/// to draw attention to featured content, such as promotions, new features,
/// or important announcements. Its styling is intentionally distinct.
public struct FeaturedCard<Content: View>: View {
    let gradient: Gradient
    @ViewBuilder let content: Content
    
    public var body: some View {
        ZStack {
            let fill = LinearGradient(
                gradient: gradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            RoundedRectangle(cornerRadius: .themeRadius.card).fill(fill)
                .oneEffect(.glow(
                    color: gradient.stops.first?.color ?? .accentColor, radius: 30)
                )
            
            content
                .padding(.themeSpacing.large)
        }
    }
}
