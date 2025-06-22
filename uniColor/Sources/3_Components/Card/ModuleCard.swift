//
//  ModuleCard.swift
//  uniColor
//
//  Created by garyrobertellis on 6/22/25.
//


import SwiftUI

/// A standard, versatile card for containing any module of content. It features
/// a subtle border and standard padding, making it the workhorse component for
/// most layouts. It's designed to group related information cleanly.
public struct ModuleCard<Content: View>: View {
    @ViewBuilder let content: Content
    
    public var body: some View {
        content
            .padding(.themeSpacing.large)
            .background(Color.theme.backgroundSecondary.swiftUIColor)
            .cornerRadius(.themeRadius.card)
            .overlay(
                RoundedRectangle(cornerRadius: .themeRadius.card)
                    .stroke(Color.theme.border.swiftUIColor, lineWidth: 1)
            )
    }
}