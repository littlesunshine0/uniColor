//
//  SensoryCore 2.swift
//  uniColor
//
//  Created by garyrobertellis on 6/22/25.
//


import SwiftUI

// This file provides convenient previews for the entire application experience.
// It is wrapped in a `#if DEBUG` block to ensure it is not compiled into
// the production build of the app.
#if DEBUG
struct SensoryCore_iOS_Preview: PreviewProvider {
    static var previews: some View {
        SensoryCoreiOSApp().body
    }
}

struct SensoryCore_macOS_Preview: PreviewProvider {
    static var previews: some View {
        SensoryCoreMacOSApp().body
            .frame(width: 900, height: 600)
    }
}