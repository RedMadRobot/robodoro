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
    private(set) var pomodoroState: PomodoroState
    
    @Published
    private(set) var timerState: TimerState
    
    @Published
    private(set) var leftTime: TimeInterval
    
    var formattedTime: String {
        dateComponentsFormatter.string(from: leftTime) ?? "NaN"
    }
    
    var stagesCount: Int {
        pomodoroService.stagesCount
    }
    
    var filledCount: Int {
        pomodoroService.completedStages
    }
    
    var showResetButton: Bool {
        timerService.canBeReseted
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
    
    var buttonImage: UIImage {
        timerState.buttonImage
    }
    
    // MARK: - Private Propeties
    
    private var pomodoroService: PomodoroService
    private var timerService: TimerService
    
    private var dateComponentsFormatter: DateComponentsFormatter = .hourAndMinutesFormatter
    
    // MARK: - Init
    
    init(
        pomodoroService: PomodoroService = DI.services.pomodoroService,
        timerService: TimerService = DI.services.timerService
    ) {
        self.pomodoroService = pomodoroService
        self.pomodoroState = pomodoroService.currentState
        self.timerService = timerService
        self.timerState = timerService.currentState
        self.leftTime = pomodoroService.currentState.waitingTime
        
        self.pomodoroService.delegate = self
        self.timerService.delegate = self
    }
    
    // MARK: - Public Methods
    
    func mainButtonAction() {
        switch timerState {
        case .initial:
            timerService.start(waitingTime: pomodoroState.waitingTime)
        case .running:
            timerService.pause()
        case .ended:
            reset()
        case .paused:
            timerService.resume()
        }
    }
    
    func reset() {
        pomodoroService.reset()
        timerService.reset()
        self.leftTime = pomodoroService.currentState.waitingTime
    }
}

// MARK: - PomodoroServiceDelegate

extension PomodoroViewModel: PomodoroServiceDelegate {
    
    func pomododoService(_ service: PomodoroService, didChangeStateTo state: PomodoroState) {
        pomodoroState = state
        guard !service.atInitialState else { return }
        timerService.start(waitingTime: pomodoroState.waitingTime)
    }
}

// MARK: - TimerServiceDelegate

extension PomodoroViewModel: TimerServiceDelegate {
    
    func timerService(_ service: TimerService, didChangeStateTo state: TimerState) {
        timerState = state
    }
    
    func timerService(_ service: TimerService, didTickAtInterval interval: TimeInterval) {
        leftTime = interval
    }
    
    func timerServiceDidFinish(_ service: TimerService) {
        pomodoroService.moveForward()
    }
}
