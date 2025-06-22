import SwiftUI

/// A single, reusable page view for the onboarding sequence. This component
/// enforces a consistent layout for each step of the onboarding process.
struct OnboardingPage: View {
    let imageName: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: imageName)
                .font(.system(size: 80))
                .foregroundStyle(Color.theme.primary.swiftUIColor)
                .oneEffect(.glow(color: .theme.primary.swiftUIColor, radius: 40))
            
            OneText(title, style: .largeTitle)
                
            OneText(subtitle, style: .headline, color: .theme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Spacer()
            Spacer()
        }
        .padding()
    }
}

/// The main view for the onboarding flow, using a TabView to present pages.
/// This view is typically shown once to a new user.
public struct OnboardingView: View {
    @Binding var isPresented: Bool
    
    public var body: some View {
        VStack(spacing: 0) {
            TabView {
                OnboardingPage(
                    imageName: "sparkles.tv.fill",
                    title: "Welcome to Sensory Core",
                    subtitle: "A unified system for building beautiful, multi-platform interfaces with SwiftUI."
                )
                OnboardingPage(
                    imageName: "switch.2",
                    title: "Dynamic Theming",
                    subtitle: "Switch between entire design systems with a single tap. Explore different looks in the Settings tab."
                )
                OnboardingPage(
                    imageName: "textformat.size",
                    title: "Dynamic Typography",
                    subtitle: "Our font system supports Dynamic Type out of the box. Change your text size in your device's settings to see it in action."
                )
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            
            OneButton(title: "Get Started", state: .constant(.normal)) {
                isPresented = false
            }
            .padding()
        }
        .background(Color.theme.background.swiftUIColor.ignoresSafeArea())
        .foregroundStyle(Color.theme.textPrimary.swiftUIColor)
    }
}
