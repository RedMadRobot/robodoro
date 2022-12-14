//
//  SwitcherStyle.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 14.12.2022.
//

import SwiftUI

struct SettingsToggleStyle: ToggleStyle {
    
    private let onColor = Color(Colors.toggleGreen)
    private let offColor = Color(Colors.textGray)
    private let thumbColor = Color(Colors.white)
    
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            configuration.label
                .font(.miniTitle)
            Spacer()
            RoundedRectangle(cornerRadius: 16, style: .circular)
                .fill(configuration.isOn ? onColor : offColor)
                .frame(width: 56, height: 32)
                .overlay(
                    Circle()
                        .fill(thumbColor)
                        .shadow(radius: 1, x: 0, y: 1)
                        .frame(width: 20, height: 20)
                        .offset(x: configuration.isOn ? 10 : -10))
                .animation(Animation.easeInOut(duration: 0.2), value: configuration.isOn)
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
}