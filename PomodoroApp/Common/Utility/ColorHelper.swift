//
//  ColorHelper.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 17.11.2022.
//

import SwiftUI

final class ColorHelper {
    
    static func getBackgroundColor(
        pomodoroState: PomodoroState,
        timerState: TimerState
    ) -> Color {
        switch timerState {
        case .initial, .paused:
            return Colors.defaultGray.swiftUIColor
        case .running, .ended:
            return pomodoroState.backgroundColor
        }
    }
    
    static func getStrokeColor(
        pomodoroState: PomodoroState,
        timerState: TimerState
    ) -> Color {
        switch timerState {
        case .initial, .paused:
            return Colors.defaultLine.swiftUIColor
        case .running, .ended:
            return pomodoroState.strokeColor
        }
    }
}
