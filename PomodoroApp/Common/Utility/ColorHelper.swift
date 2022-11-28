//
//  ColorHelper.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 17.11.2022.
//

import UIKit

final class ColorHelper {
    
    static func getBackgroundColor(
        pomodoroState: PomodoroState,
        timerState: TimerState
    ) -> UIColor {
        switch timerState {
        case .initial, .paused:
            return Colors.pauseBackground
        case .running, .ended:
            return pomodoroState.backgroundColor
        }
    }
    
    static func getStrokeColor(
        pomodoroState: PomodoroState,
        timerState: TimerState
    ) -> UIColor {
        switch timerState {
        case .initial, .paused:
            return Colors.pauseLine
        case .running, .ended:
            return pomodoroState.strokeColor
        }
    }
}
