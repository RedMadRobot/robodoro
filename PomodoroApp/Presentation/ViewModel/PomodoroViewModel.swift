//
//  PomodoroViewModel.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 11.11.2022.
//

import Foundation

final class PomodoroViewModel: ObservableObject {
    
    // MARK: - Public Properties
    
    var pomodoroState: PomodoroState = .focus
    var timerState: TimerState = .running
}
