//
//  ComponentGalleryView.swift
//  uniColor
//
//  Created by garyrobertellis on 6/22/25.
//


import SwiftUI

/// A view that displays a gallery of all core components for testing and review.
/// This is an essential developer tool for visualizing the design system.
public struct ComponentGalleryView: View {
    @State private var buttonState: OneState = .normal
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                gallerySection(title: "Buttons") {
                    OneButton(title: "Run Action", state: $buttonState) {
                        buttonState = .loading
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            buttonState = .success
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                buttonState = .normal
                            }
                        }
                    }
                }
                
                gallerySection(title: "Badges") {
                    HStack {
                        OneBadge("Default")
                        OneBadge("Success", color: .theme.success, icon: "checkmark.circle")
                        OneBadge("Warning", color: .theme.warning, icon: "exclamationmark.triangle")
                        OneBadge("Error", color: .theme.destructive, icon: "xmark.octagon")
                    }
                }
                
                gallerySection(title: "App Icons") {
                    HStack(spacing: 20) {
                        IOSAppIcon().frame(width: 60, height: 60)
                        MacOSAppIcon().frame(width: 60, height: 60)
                        WatchOSAppIcon().frame(width: 60, height: 60)
                    }
                }
            }
            .padding()
        }
        .background(Color.theme.background.swiftUIColor.ignoresSafeArea())
        .navigationTitle("Component Gallery")
    }
    
    @ViewBuilder
    private func gallerySection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: .themeSpacing.medium) {
            OneText(title, style: .largeTitle)
            ModuleCard {
                content()
                    .frame(maxWidth: .infinity)
            }
        }
    }
}
