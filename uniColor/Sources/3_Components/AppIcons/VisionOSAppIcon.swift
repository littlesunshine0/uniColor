//
//  VisionOSAppIcon.swift
//  uniColor
//
//  Created by garyrobertellis on 6/22/25.
//


import SwiftUI

#if canImport(RealityKit)
import RealityKit

/// A representation of the app icon for visionOS, designed for a 3D,
/// spatial context. It may be volumetric and should have depth and texture
/// that respond to the user's gaze and the environment's lighting.
public struct VisionOSAppIcon: View {
    public var body: some View {
        ZStack {
            // A subtle glass background to catch reflections.
            Circle().fill(.white.opacity(0.1))
            
            // A 3D-like shape using gradients and shadows to imply volume.
            Circle()
                .fill(Color.theme.primary.swiftUIColor)
                .shadow(color: .black.opacity(0.4), radius: 20, x: 0, y: 10)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.5), lineWidth: 2)
                        .blur(radius: 2)
                )
                .padding(20)
        }
        .oneEffect(.glass)
        .clipShape(Circle())
    }
}
#endif