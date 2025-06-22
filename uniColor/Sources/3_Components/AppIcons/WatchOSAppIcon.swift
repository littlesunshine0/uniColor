//
//  WatchOSAppIcon.swift
//  uniColor
//
//  Created by garyrobertellis on 6/22/25.
//


import SwiftUI

/// A representation of the app icon for watchOS, which is always circular
/// to match the device's screen and UI conventions. The design must be
/// simple and highly legible at very small sizes.
public struct WatchOSAppIcon: View {
    public var body: some View {
        GeometryReader { geo in
            ZStack {
                Circle().fill(Color.black)
                
                Circle()
                    .trim(from: 0.2, to: 1.0)
                    .stroke(
                        Color.theme.primary.swiftUIColor,
                        style: StrokeStyle(lineWidth: geo.size.width * 0.1, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-180))
                    .frame(width: geo.size.width * 0.65)
            }
        }
    }
}
