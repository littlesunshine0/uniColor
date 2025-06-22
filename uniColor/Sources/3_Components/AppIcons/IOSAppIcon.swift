//
//  IOSAppIcon.swift
//  uniColor
//
//  Created by garyrobertellis on 6/22/25.
//


import SwiftUI

/// A representation of the app icon designed for iOS, following
/// standard super-ellipse conventions. The design is intended to be clean,
/// modern, and instantly recognizable on a user's home screen.
public struct IOSAppIcon: View {
    public var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.white
                RoundedRectangle(cornerRadius: geo.size.width * 0.22)
                    .fill(Color.theme.primary.swiftUIColor.gradient)
                    .frame(width: geo.size.width * 0.6, height: geo.size.width * 0.6)
                Circle()
                    .stroke(Color.white, lineWidth: geo.size.width * 0.05)
                    .frame(width: geo.size.width * 0.25)
            }
            .clipShape(RoundedRectangle(cornerRadius: geo.size.width * 0.22, style: .continuous))
        }
    }
}