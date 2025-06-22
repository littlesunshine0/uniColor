//
//  OneIconType.swift
//  uniColor
//
//  Created by garyrobertellis on 6/21/25.
//


import SwiftUI

/// Defines the source type for an icon.
public enum OneIconType {
    case sfSymbol(name: String)
    // Placeholders for future expansion
    // case svg(name: String)
    // case lottie(name: String)
}

/// A universal, theme-aware, and interactive icon component.
public struct OneIcon: View {
    let iconType: OneIconType
    @Binding var state: OneState
    var action: (() -> Void)? = nil

    public var body: some View {
        iconView
            .font(.system(size: 32, weight: .medium))
            .foregroundStyle(color.swiftUIColor.gradient)
            .scaleEffect(state == .pressed ? 0.9 : 1.0)
            .opacity(state == .disabled ? 0.4 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: state)
            .if(action != nil) { view in
                view.onPrimaryAction(perform: action!)
            }
    }
    
    @ViewBuilder
    private var iconView: some View {
        switch iconType {
        case .sfSymbol(let name):
            Image(systemName: name)
        }
    }
    
    private var color: UnifiedColor {
        switch state {
        case .success:
            return Theme.Colors.success
        case .error:
            return Theme.Colors.destructive
        default:
            return Theme.Colors.textPrimary
        }
    }
}