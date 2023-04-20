//
//  ButtonStyle.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 12.12.2022.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(24)
            .font(.regularTitle)
            .foregroundColor(Colors.white.suColor)
            .background(Colors.black.suColor)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(24)
            .font(.regularTitle)
            .foregroundColor(Colors.black.suColor)
            .background(Colors.white.suColor)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Colors.black.suColor))
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
