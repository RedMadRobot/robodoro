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
        timerState.isPaused
            ? timerState.backgroundColor
            : pomodoroState.backgroundColor
    }
    
    static func getStrokeColor(
        pomodoroState: PomodoroState,
        timerState: TimerState
    ) -> UIColor {
        timerState.isPaused
            ? timerState.strokeColor
            : pomodoroState.strokeColor
    }
}
