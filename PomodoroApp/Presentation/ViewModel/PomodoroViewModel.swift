//
//  PomodoroViewModel.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 11.11.2022.
//

import SwiftUI

final class PomodoroViewModel: ObservableObject {

    // MARK: - Public Properties
    
    @Published
    private(set) var pomodoroState: PomodoroState = .focus
    
    @Published
    private(set) var showingTime: String = "25:00"
    
    @Published
    private(set) var timerState: TimerState = .running
    
    var stagesCount: Int {
        pomodoroService.stagesCount
    }
    
    var filledCount: Int {
        pomodoroService.completedStages
    }
    
    var showResetButton: Bool {
        !pomodoroService.atInitialState
    }
    
    var backgroundColor: UIColor {
        timerState.isPaused
            ? timerState.backgroundColor
            : pomodoroState.backgroundColor
    }
    
    var strokeColor: UIColor {
        timerState.isPaused
            ? timerState.strokeColor
            : pomodoroState.strokeColor
    }
    
    // MARK: - Private Propeties
    
    private var pomodoroService: PomodoroService
    
    // MARK: - Init
    
    init(pomodoroService: PomodoroService = DI.services.pomodoroService) {
        self.pomodoroService = pomodoroService
        self.pomodoroState = pomodoroService.currentState

        pomodoroService.delegate = self
    }
    
    // MARK: - Public Methods
    
    func pause() {
        if timerState == .running {
            timerState = .paused
        } else {
            timerState = .running
        }
    }
    
    func moveForward() {
        pomodoroService.moveForward()
    }
    
    func reset() {
        pomodoroService.reset()
    }
}

// MARK: - PomodoroServiceDelegate

extension PomodoroViewModel: PomodoroServiceDelegate {
    
    func pomododoService(_ service: PomodoroService, didChangeStateTo state: PomodoroState) {
        pomodoroState = state
    }
}
