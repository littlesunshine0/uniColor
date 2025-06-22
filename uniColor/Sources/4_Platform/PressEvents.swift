//
//  PressEvents.swift
//  uniColor
//
//  Created by garyrobertellis on 6/22/25.
//


import SwiftUI

// A generic press event handler that works across platforms by using a DragGesture.
// This is essential for components like `OneButton` that need to react to the
// press-down and release-up phases of an interaction.
public extension View {
    func pressEvents(
        onPress: @escaping (() -> Void),
        onRelease: @escaping (() -> Void)
    ) -> some View {
        self.gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in onPress() }
                .onEnded { _ in onRelease() }
        )
    }