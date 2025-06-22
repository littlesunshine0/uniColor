//
//  CardDemoView.swift
//  uniColor
//
//  Created by garyrobertellis on 6/22/25.
//


import SwiftUI

/// A view specifically for demonstrating the different card components. This
/// allows designers and developers to see all card styles side-by-side.
struct CardDemoView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                HeroCard {
                    OneText("Hero Card", style: .largeTitle)
                }
                
                FeaturedCard(gradient: Gradient(colors: [.pink, .orange])) {
                    HStack {
                        OneIcon(systemName: "star.fill", size: 24)
                        OneText("Featured Card", style: .headline)
                    }.foregroundStyle(.white)
                }

                StatCard(title: "Active Users", value: "1,234", iconName: "person.2.fill")
                
                ModuleCard {
                    OneText("This is a standard Module Card, perfect for containing sections of content.", style: .body)
                }
                
                RowCard {
                    OneIcon(systemName: "checkmark.seal.fill", size: 20)
                    OneText("Row Card for list items", style: .body)
                }
                
                LandingCard(iconName: "leaf.fill", title: "Landing Card", subtitle: "Introduce a key feature or idea.")
            }.padding()
        }
        .navigationTitle("Card Demo")
        .background(Color.theme.background.swiftUIColor)
    }
}

File: 5_App/Demos/EffectDemoView.swift
