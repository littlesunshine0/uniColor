//
//  SettingsView.swift
//  uniColor
//
//  Created by garyrobertellis on 6/22/25.
//


import SwiftUI

/// A simple settings view, primarily for changing the active theme. This view
/// demonstrates how easily the `uniTheme` manager can be used to control the
/// application's entire look and feel.
public struct SettingsView: View {
    @EnvironmentObject private var themeManager: uniTheme

    public var body: some View {
        Form {
            Section("Appearance") {
                Picker("Theme", selection: .init(
                    get: { themeManager.currentDesignSystem.name },
                    set: { themeManager.applyDesignSystem(named: $0) }
                )) {
                    ForEach(themeManager.availableDesignSystems) { system in
                        Text(system.name).tag(system.name)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.vertical, 5)
            }
            
            Section("About") {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("3.0.1 - Stability Patch")
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Settings")
    }
}
