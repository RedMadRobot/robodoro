//
//  PomodoroViewModel.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 11.11.2022.
//

import ActivityKit
import Combine
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
        getFormattedTime(time: leftTime)
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
        ColorHelper.getBackgroundColor(
            pomodoroState: pomodoroState,
            timerState: timerState)
    }
    
    var strokeColor: UIColor {
        ColorHelper.getStrokeColor(
            pomodoroState: pomodoroState,
            timerState: timerState)
    }
    
    var buttonImage: UIImage {
        timerState.buttonImage
    }
    
    // MARK: - Private Propeties
    
    private var activityService: LiveActivityService
    private var pomodoroService: PomodoroService
    private var timerService: TimerService
    
    private var dateComponentsFormatter: DateComponentsFormatter = .hourAndMinutesFormatter
    
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(
        activityService: LiveActivityService = DI.services.activityService,
        pomodoroService: PomodoroService = DI.services.pomodoroService,
        timerService: TimerService = DI.services.timerService
    ) {
        self.activityService = activityService
        self.pomodoroService = pomodoroService
        self.pomodoroState = pomodoroService.currentState
        self.timerService = timerService
        self.timerState = timerService.currentState
        self.leftTime = pomodoroService.currentState.waitingTime
        
        self.pomodoroService.delegate = self
        self.timerService.delegate = self
        
        addSubsctiptions()
    }
    
    // MARK: - Public Methods
    
    func mainButtonAction() {
        switch timerState {
        case .initial:
            activityService.start(
                pomodoroState: pomodoroState,
                timerState: timerState,
                leftTime: formattedTime,
                stagesCount: stagesCount,
                filledCount: filledCount)
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
    
    // MARK: - Private Properties
    
    private func addSubsctiptions() {
        $pomodoroState.sink { [weak self] state in
            guard state != self?.pomodoroState else { return }
            self?.updateActivity(newPomodoroState: state)
        }
        .store(in: &subscriptions)
        $timerState.sink { [weak self] state in
            guard state != self?.timerState else { return }
            self?.updateActivity(newTimerState: state)
        }
        .store(in: &subscriptions)
        $leftTime.sink { [weak self] leftTime in
            self?.updateActivity(newLeftTime: leftTime)
        }
        .store(in: &subscriptions)
    }
    
    private func updateActivity(
        newPomodoroState: PomodoroState? = nil,
        newTimerState: TimerState? = nil,
        newLeftTime: TimeInterval? = nil
    ) {
        let newFormattedTime = getFormattedTime(time: newLeftTime ?? leftTime)
        activityService.update(
            pomodoroState: newPomodoroState ?? pomodoroState,
            timerState: newTimerState ?? timerState,
            leftTime: newFormattedTime,
            filledCount: filledCount)
    }
    
    private func getFormattedTime(time: TimeInterval) -> String {
        dateComponentsFormatter.string(from: time) ?? "NaN"
    }
}

// MARK: - PomodoroServiceDelegate

extension PomodoroViewModel: PomodoroServiceDelegate {
    
    func pomododoService(_ service: PomodoroService, didChangeStateTo state: PomodoroState) {
        pomodoroState = state
        guard !service.atInitialState else { return }
        timerService.start(waitingTime: pomodoroState.waitingTime)
    }
    
    func pomodoroServiceDidFinishCycle(_ service: PomodoroService) {
        timerService.stop()
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
