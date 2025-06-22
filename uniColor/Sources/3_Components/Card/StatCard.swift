//
//  StatCard.swift
//  uniColor
//
//  Created by garyrobertellis on 6/22/25.
//


import SwiftUI

/// A compact card for displaying a key statistic or metric. It prominently
/// features a large value and a descriptive label.
public struct StatCard: View {
    let title: String
    let value: String
    let iconName: String?
    
    public var body: some View {
        ModuleCard {
            VStack(spacing: .themeSpacing.xsmall) {
                HStack {
                    OneText(title, style: .caption, color: .theme.textSecondary)
                    if let iconName {
                        Spacer()
                        OneIcon(systemName: iconName, size: 16)
                            .foregroundStyle(Color.theme.textSecondary.swiftUIColor)
                    }
                }
                OneText(value, style: .largeTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}
