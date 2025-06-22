//  OneButton.swift
//  uniColor
//
//  Created by garyrobertellis on 6/21/25.
//

// NOTE: This file assumes the existence of:
// - A 'Theme' struct or class with static properties like 'radiusStandard', 'spacingMedium', 'spacingLarge'.
// - A 'UnifiedColor' struct or enum with static properties like '.muted', '.accent', '.white'.
// - A custom 'Font.theme' extension for accessing themed fonts.
// - A custom 'Color.theme' extension for accessing themed colors as SwiftUI.Color.
// - A custom View extension or struct providing 'pressEvents' functionality (replaced here with standard gestures).
// - A custom ViewModifier or function for the '.shimmerEffect()' placeholder.

import SwiftUI

public struct OneButton: View {
    let title: String
    @Binding var state: OneState
    let action: () -> Void

    // Internal state for hover and press
    @State private var isHovering = false
    @State private var isPressed = false

    public var body: some View {
        Button(action: {
            if state == .normal {
                action()
            }
        }) {
            ZStack {
                // Base look
                // FIX: Access radiusStandard directly from Theme (assuming static member)
                RoundedRectangle(cornerRadius: Theme.radiusStandard)
                    .fill(backgroundColor.swiftUIColor.gradient) // Use gradient for depth
                    .shadow(color: shadowColor, radius: shadowRadius, y: shadowY)

                // Shimmer effect for loading state
                if state == .loading {
                    // Placeholder for a shimmer effect ViewModifier
                    // FIX: Placeholder for custom shimmer effect - Uncomment/Implement if available
                    RoundedRectangle(cornerRadius: Theme.radiusStandard) // Assuming Theme.radiusStandard again
                        .fill(Color.white.opacity(0.2))
                        // .shimmerEffect() // Example of a custom effect
                }

                // Title or ProgressView
                // FIX: Access spacingMedium directly from Theme (assuming static member)
                // FIX: Access spacingLarge directly from Theme (assuming static member)
                // FIX: Access spacingMedium directly from Theme (assuming static member)
                HStack(spacing: Theme.spacingMedium) {
                    if state == .loading {
                        ProgressView().tint(.white)
                    } else {
                        Text(title)
                            // FIX: Access themed headline font using custom Font.theme extension
                            .font(.theme.headline)
                            .fontWeight(.bold)
                            .foregroundColor(foregroundColor.swiftUIColor)
                    }
                }
                .padding(.horizontal, Theme.spacingLarge)
                .padding(.vertical, Theme.spacingMedium)
            }
        }
        .buttonStyle(.plain) // Use a plain style to control everything
        .disabled(state != .normal)
        .scaleEffect(isPressed ? 0.97 : 1.0) // Bounce on press
        .brightness(isHovering ? 0.1 : 0.0) // Glow on hover
        .animation(Animation.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .animation(Animation.easeInOut(duration: 0.2), value: isHovering)
        .animation(.easeInOut, value: state) // Animate state changes
        .onHover { hovering in
            isHovering = hovering
        }
        // FIX: Replace custom 'pressEvents' modifier with standard SwiftUI gestures
        // Use a zero-duration long press gesture to detect press down and release.
        .onLongPressGesture(minimumDuration: 0, perform: { }) { pressed in
             isPressed = pressed
        }
    }

    // MARK: - State-Driven Visuals
    private var backgroundColor: UnifiedColor {
        switch state {
        // FIX: Access muted color directly from UnifiedColor (assuming static member)
        case .disabled: return UnifiedColor.muted
        // FIX: Access accent color directly from UnifiedColor (assuming static member)
        case .pressed: return UnifiedColor.accent.withOpacity(0.8) // Assuming withOpacity exists on UnifiedColor
        // FIX: Access accent color directly from UnifiedColor (assuming static member)
        default: return UnifiedColor.accent
        }
    }

    private var foregroundColor: UnifiedColor {
        // FIX: Access white color directly from UnifiedColor (assuming static member)
        UnifiedColor.white
    }

    private var shadowColor: Color {
        state == .disabled ? .clear : .black.opacity(0.3)
    }

    private var shadowRadius: CGFloat {
        isPressed ? 4 : 8
    }

    private var shadowY: CGFloat {
        isPressed ? 2 : 4
    }
}


// MARK: - Preview

struct OneButton_Previews: PreviewProvider {
    // NOTE: This preview assumes the existence of:
    // - A 'Theme' struct or class with static properties like 'radiusStandard', 'spacingMedium', 'spacingLarge'.
    // - A 'UnifiedColor' struct or enum with static properties like '.muted', '.accent', '.white'.
    // - A custom 'Font.theme' extension for accessing themed fonts.
    // - A custom 'Color.theme' extension for accessing themed colors as SwiftUI.Color.
    // - An 'uniTheme' environment object type with a 'shared' instance.
    static var previews: some View {
        VStack(spacing: 20) { // Assuming '20' is an intended fixed spacing, not themed.
            OneButton(title: "Normal State", state: .constant(.normal), action: {})
            OneButton(title: "Pressed State", state: .constant(.pressed), action: {})
            OneButton(title: "Loading...", state: .constant(.loading), action: {})
            OneButton(title: "Disabled", state: .constant(.disabled), action: {})
            OneButton(title: "Success", state: .constant(.success), action: {})
        }
        .padding() // Assuming default padding is intended.
        // FIX: Remove redundant .swiftUIColor when using Color.theme extension
        .background(Color.theme.background.ignoresSafeArea()) // Assuming Color.theme returns SwiftUI.Color
        .frame(width: 300) // Assuming fixed frame width.
        // FIX: Ensure Theme environment object is available for Color.theme extension
        .environmentObject(uniTheme.shared) // Assume uniTheme is the environment object type
    }
}
