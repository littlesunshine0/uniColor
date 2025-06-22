//
//  MacOSAppIcon.swift
//  uniColor
//
//  Created by garyrobertellis on 6/22/25.
//


import SwiftUI

/// A representation of the app icon for macOS, typically featuring
/// a squircle shape with a slight shadow or depth to give it a tactile
/// feel within the Dock. It often contains the iOS icon as a glyph.
public struct MacOSAppIcon: View {
    public var body: some View {
        GeometryReader { geo in
            ZStack {
                RoundedRectangle(cornerRadius: geo.size.width * 0.18, style: .continuous)
                    .fill(Color.theme.backgroundSecondary.swiftUIColor)
                    .shadow(radius: 2, y: 1)
                
                IOSAppIcon()
                    .scaleEffect(0.8)
            }
        }
    }
}