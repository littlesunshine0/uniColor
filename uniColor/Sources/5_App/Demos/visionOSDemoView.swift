//
//  visionOSDemoView.swift
//  uniColor
//
//  Created by garyrobertellis on 6/21/25.
//


import SwiftUI

// This view is only available on visionOS
#if os(visionOS)
struct visionOSDemoView: View {
    @State private var buttonState: OneState = .normal

    var body: some View {
        RealityContainer {
            VStack(spacing: 30) {
                Text("Sensory Core for visionOS")
                    .font(.extraLargeTitle)
                
                Text("Components are designed for spatial interaction.")
                    .font(.title)
                
                // OneButton works seamlessly with its state logic.
                // The primary action is triggered by a pinch gesture.
                OneButton(title: "Initiate Scan", state: $buttonState) {
                    // Simulate a task
                    buttonState = .loading
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        buttonState = .success
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            buttonState = .normal
                        }
                    }
                }
                .frame(width: 300)
            }
        }
        .environmentObject(uniTheme.shared)
    }
}

struct visionOSDemoView_Previews: PreviewProvider {
    static var previews: some View {
        visionOSDemoView()
    }
}
#endif