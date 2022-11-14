//
//  BackgroundView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 14.11.2022.
//

import SwiftUI

struct BackgroundView: View {
    
    // MARK: - Private Properties
    
    private var pomodoroState: PomodoroState
    private var timerState: TimerState
    
    private var backgroundColor: UIColor {
        timerState.isPaused
            ? timerState.backgroundColor
            : pomodoroState.backgroundColor
    }
    
    private var strokeColor: UIColor {
        timerState.isPaused
            ? timerState.strokeColor
            : pomodoroState.strokeColor
    }
    
    // MARK: - Init
    
    init(
        pomodoroState: PomodoroState,
        timerState: TimerState
    ) {
        self.pomodoroState = pomodoroState
        self.timerState = timerState
    }
    
    // MARK: - View
    
    var body: some View {
        switch pomodoroState {
        case .focus:
            FocusedBackground(
                backgroundColor: backgroundColor,
                strokeColor: strokeColor)
        case .break:
            BreakBackground()
        case .longBreak:
            LongBreakBackground()
        }
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView(
            pomodoroState: .focus,
            timerState: .running)
    }
}
