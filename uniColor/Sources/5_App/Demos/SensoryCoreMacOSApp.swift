//
//  SensoryCoreMacOSApp.swift
//  uniColor
//
//  Created by garyrobertellis on 6/22/25.
//


import SwiftUI

// The main entry point for the macOS application.
// @main
struct SensoryCoreMacOSApp: App {
    @StateObject private var themeManager = uniTheme.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationSplitView {
                List {
                    NavigationLink("Home", destination: HomeView())
                    NavigationLink("Typography", destination: TypographyDemoView())
                    NavigationLink("Cards", destination: CardDemoView())
                    NavigationLink("Gallery", destination: ComponentGalleryView())
                }
                .listStyle(.sidebar)
                .navigationTitle("Sensory Core")
            } detail: {
                TypographyDemoView()
            }
            .environmentObject(themeManager)
            .onAppear {
                // Default to the darker theme for the macOS app.
                themeManager.applyDesignSystem(named: "Documentation")
            }
        }
        .windowStyle(.hiddenTitleBar)
        
        Settings {
            // Provide a standard macOS settings window.
            SettingsView()
                .padding()
                .frame(width: 400, height: 200)
                .environmentObject(themeManager)
        }
    }
}
