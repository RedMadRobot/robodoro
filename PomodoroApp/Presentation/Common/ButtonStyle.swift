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
            .font(.custom(TextStyle.regularTitle.font.stringName, size: TextStyle.regularTitle.size))
            .foregroundColor(Colors.white.swiftUIColor)
            .background(Colors.black.swiftUIColor)
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
            .font(.custom(TextStyle.regularTitle.font.stringName, size: TextStyle.regularTitle.size))
            .foregroundColor(Colors.black.swiftUIColor)
            .background(Colors.white.swiftUIColor)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Colors.black.swiftUIColor))
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
