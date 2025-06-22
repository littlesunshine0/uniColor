//
//  HeroCard.swift
//  uniColor
//
//  Created by garyrobertellis on 6/22/25.
//


import SwiftUI

/// A large, prominent card style for showcasing hero content, such as a welcome
/// message or a page title. It uses significant padding and a noticeable shadow
/// to create a sense of importance and command attention.
public struct HeroCard<Content: View>: View {
    @ViewBuilder let content: Content
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: .themeRadius.card)
                .fill(Color.theme.backgroundSecondary.swiftUIColor)
                .oneEffect(.shadow(color: .black.opacity(0.1), radius: 20, y: 10))
            
            content
                .padding(.themeSpacing.large * 2)
        }
    }
}