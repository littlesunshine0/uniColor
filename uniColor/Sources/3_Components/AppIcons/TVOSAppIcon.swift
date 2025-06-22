//
//  TVOSAppIcon.swift
//  uniColor
//
//  Created by garyrobertellis on 6/22/25.
//


import SwiftUI

/// A representation of the app icon for tvOS. It's layered and can
/// produce parallax effects when focused, creating an engaging "10-foot"
/// experience. The asset is typically a 16:9 rectangle.
public struct TVOSAppIcon: View {
    public var body: some View {
        ZStack {
            // The back layer moves less during the parallax effect.
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.theme.primary.swiftUIColor.opacity(0.5))
                .shadow(radius: 10)
            
            // The front layer moves more, creating a sense of depth.
            Image(systemName: "wand.and.stars")
                .font(.system(size: 80))
                .foregroundStyle(.white)
        }
        .frame(width: 400, height: 240)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}