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
        timerState: TimerState,
        isPomodoroFihished: Bool
    ) -> UIColor {
        switch (timerState, isPomodoroFihished) {
        case (.initial, _), (.paused, _), (.ended, false):
            return Colors.pauseBackground
        case (.running, _), (.ended, true):
            return pomodoroState.backgroundColor
        }
    }
    
    static func getStrokeColor(
        pomodoroState: PomodoroState,
        timerState: TimerState,
        isPomodoroFihished: Bool
    ) -> UIColor {
        switch (timerState, isPomodoroFihished) {
        case (.initial, _), (.paused, _), (.ended, false):
            return Colors.pauseLine
        case (.running, _), (.ended, true):
            return pomodoroState.strokeColor
        }
    }
}
