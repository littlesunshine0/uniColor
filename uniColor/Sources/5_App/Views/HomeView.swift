import SwiftUI

/// The main landing view of the application, showcasing the key features
/// and providing navigation to other parts of the app.
public struct HomeView: View {
    public var body: some View {
        ScrollView {
            VStack(spacing: .themeSpacing.large) {
                HeroCard {
                    VStack(spacing: .themeSpacing.xsmall) {
                        // The asset name is pulled from a token.
                        Image(.themeAsset.logo)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 80)
                        OneText("The Unified Interface System", style: .headline, color: .theme.textSecondary)
                    }
                }
                
                FeaturedCard(gradient: Gradient(colors: [.purple, .blue])) {
                    HStack {
                        OneIcon(systemName: "wand.and.stars")
                        OneText("Dynamic & Refactored to V3.0.1", style: .headline)
                    }
                    .foregroundStyle(.white)
                }
                
                LandingCard(iconName: "textformat.size", title: "Dynamic Typography", subtitle: "Explore our new font system in the Typography tab.")
                
                LandingCard(iconName: "square.stack.3d.up.fill", title: "Component Gallery", subtitle: "See all available components, cards, and effects.")

                LandingCard(iconName: "creditcard.fill", title: "Card Styles", subtitle: "Review the different card components for various layouts.")
            }
            .padding()
        }
        .background(Color.theme.background.swiftUIColor.ignoresSafeArea())
        .navigationTitle("Home")
    }
}
