//
//  EffectDemoView.swift
//  uniColor
//
//  Created by garyrobertellis on 6/22/25.
//


import SwiftUI

/// A view for demonstrating the `OneEffect` modifiers, making it easy to
/// visualize and debug the appearance of shadows, glows, and materials.
struct EffectDemoView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                effectRow(title: "Glass Effect")
                    .oneEffect(.glass)
                
                effectRow(title: "Glow Effect")
                    .oneEffect(.glow(color: .theme.primary.swiftUIColor, radius: 25))
                
                effectRow(title: "Shadow Effect")
                    .oneEffect(.shadow(color: .black.opacity(0.2), radius: 10, y: 5))
            }
            .padding(30)
        }
        .navigationTitle("Effect Demo")
        .background(Color.theme.background.swiftUIColor.ignoresSafeArea())
    }
    
    private func effectRow(title: String) -> some View {
        OneText(title, style: .headline)
            .padding(25)
            .frame(maxWidth: .infinity)
            .background(Color.theme.backgroundSecondary.swiftUIColor)
            .cornerRadius(.themeRadius.standard)
    }
}
