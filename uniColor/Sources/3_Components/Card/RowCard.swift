//
//  RowCard.swift
//  uniColor
//
//  Created by garyrobertellis on 6/22/25.
//


import SwiftUI

/// A card optimized for horizontal content, such as an item in a list or a
/// table row. It has less vertical padding and a standard corner radius to
/// ensure it tiles cleanly when stacked vertically.
public struct RowCard<Content: View>: View {
    @ViewBuilder let content: Content
    
    public var body: some View {
        HStack {
            content
            Spacer()
        }
        .padding()
        .background(Color.theme.backgroundSecondary.swiftUIColor)
        .cornerRadius(.themeRadius.standard)
    }
}