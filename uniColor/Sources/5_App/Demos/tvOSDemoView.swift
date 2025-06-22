//
//  tvOSDemoView.swift
//  uniColor
//
//  Created by garyrobertellis on 6/21/25.
//


import SwiftUI

// This view is only available on tvOS
#if os(tvOS)
struct tvOSDemoView: View {
    @State private var iconOneState: OneState = .normal
    @State private var iconTwoState: OneState = .normal
    @State private var iconThreeState: OneState = .normal

    var body: some View {
        VStack(spacing: 60) {
            Text("Sensory Core on tvOS")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(Color.theme.textPrimary)

            Text("Use the remote to see focus effects.")
                .font(.headline)
                .foregroundStyle(Color.theme.textSecondary)

            HStack(spacing: 80) {
                // Each icon is focus-aware and has a primary action.
                OneIcon(iconType: .sfSymbol(name: "play.tv"), state: $iconOneState) {
                    iconOneState = (iconOneState == .success) ? .normal : .success
                }
                .focusAware()
                
                OneIcon(iconType: .sfSymbol(name: "film"), state: $iconTwoState) {
                    iconTwoState = (iconTwoState == .success) ? .normal : .success
                }
                .focusAware()

                OneIcon(iconType: .sfSymbol(name: "music.note"), state: $iconThreeState) {
                    iconThreeState = (iconThreeState == .success) ? .normal : .success
                }
                .focusAware()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.theme.background.ignoresSafeArea())
        .environmentObject(uniTheme.shared)
    }
}

struct tvOSDemoView_Previews: PreviewProvider {
    static var previews: some View {
        tvOSDemoView()
    }
}
#endif