//
//  LandingCard.swift
//  uniColor
//
//  Created by garyrobertellis on 6/22/25.
//


import SwiftUI

/// A card specifically designed for landing pages or feature introductions. It
/// typically contains an icon, title, and subtitle to communicate a key concept
/// or benefit at a glance.
public struct LandingCard: View {
    let iconName: String
    let title: String
    let subtitle: String

    public var body: some View {
        ModuleCard {
            VStack(spacing: .themeSpacing.medium) {
                OneIcon(systemName: iconName, size: 40)
                    .foregroundStyle(Color.theme.primary.swiftUIColor)
                
                OneText(title, style: .headline)
                
                OneText(subtitle, style: .body, color: .theme.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
    }
}
