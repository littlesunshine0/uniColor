//
//  TypographyDemoView.swift
//  uniColor
//
//  Created by garyrobertellis on 6/21/25.
//


import SwiftUI

/// A view dedicated to showcasing the new dynamic font system. It allows for
/// testing Dynamic Type scaling, font variants, weights, and contextual features.
public struct TypographyDemoView: View {
    @Environment(\.sizeCategory) private var sizeCategory
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                gallerySection(title: "Dynamic Type Scaling") {
                    VStack(alignment: .leading, spacing: 10) {
                        OneText("This body text scales automatically.", style: .body)
                        OneText("This headline also scales.", style: .headline)
                        OneText("And this large title.", style: .largeTitle)
                        OneText("Current Size Category: \(String(describing: sizeCategory))", style: .caption)
                            .padding(.top)
                            .foregroundStyle(Color.theme.textSecondary.swiftUIColor)
                    }
                }
                
                gallerySection(title: "Font Variants & Weights") {
                    VStack(alignment: .leading, spacing: 10) {
                        OneText("SJ Elite (Regular)", font: FontProvider.font(for: .init(family: .sjElite, size: 17, weight: .regular)))
                        OneText("SJ Elite (Italic)", font: Theme.Fonts.bodyItalic)
                        OneText("SJ Elite (Heavy)", font: FontProvider.font(for: .init(family: .sjElite, size: 17, weight: .heavy)))
                        OneText("SJ Mini (For captions)", font: .theme(for: .caption))
                        OneText("Uni SJ (For code)", font: .theme(for: .monospace))
                    }
                }
                
                gallerySection(title: "Contextual Features") {
                    HStack {
                        OneText("The time is: ", style: .headline)
                        TimeFormattedText(Date(), font: .theme(for: .headline))
                    }
                }
            }
            .padding()
        }
        .background(Color.theme.background.swiftUIColor.ignoresSafeArea())
        .navigationTitle("Typography")
    }
    
    @ViewBuilder
    private func gallerySection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: .themeSpacing.medium) {
            OneText(title, style: .largeTitle)
            ModuleCard {
                content()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}
