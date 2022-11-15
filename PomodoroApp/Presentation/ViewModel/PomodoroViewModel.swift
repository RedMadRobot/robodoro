//
//  PomodoroViewModel.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 11.11.2022.
//

import Foundation

final class PomodoroViewModel: ObservableObject {
    
    // MARK: - Public Properties
    
    var pomodoroState: PomodoroState {
        states.first ?? .longBreak
    }
    var timerState: TimerState = .running
    
    // MARK: - Private Propeties
    
    @Published
    private var states: [PomodoroState] = [.focus, .break, .focus, .break, .focus, .longBreak]
    
    // MARK: - Public Methods
    
    func moveState() {
        let currentState = states.removeFirst()
        states.append(currentState)
    }
    
}
