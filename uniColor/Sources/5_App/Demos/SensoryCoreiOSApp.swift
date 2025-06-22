//
//  SensoryCoreiOSApp.swift
//  uniColor
//
//  Created by garyrobertellis on 6/22/25.
//


import SwiftUI

// The main entry point for the iOS application.
// @main
struct SensoryCoreiOSApp: App {
    @StateObject private var themeManager = uniTheme.shared
    @State private var showOnboarding = true
    
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationView { HomeView() }
                    .tabItem { Label("Home", systemImage: "house.fill") }

                NavigationView { TypographyDemoView() }
                    .tabItem { Label("Typography", systemImage: "textformat.size") }

                NavigationView { CardDemoView() }
                    .tabItem { Label("Cards", systemImage: "rectangle.3.group.fill") }
                
                NavigationView { ComponentGalleryView() }
                    .tabItem { Label("Gallery", systemImage: "square.grid.2x2.fill") }

                NavigationView { SettingsView() }
                    .tabItem { Label("Settings", systemImage: "gear") }
            }
            .environmentObject(themeManager)
            .sheet(isPresented: $showOnboarding) {
                OnboardingView(isPresented: $showOnboarding)
            }
        }
    }
}
