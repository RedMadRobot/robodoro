//
//  TimedPomodoroWorker.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 17.11.2022.
//

import Combine
import Foundation

// MARK: - TimedPomodoroWorker

protocol TimedPomodoroWorker {
    var pomodoroState: CurrentValueSubject<PomodoroState, Never> { get }
    var timerState: CurrentValueSubject<TimerState, Never> { get }
    var leftTime: CurrentValueSubject<TimeInterval, Never> { get }
    
    var formattedTime: String { get }
    var stagesCount: Int { get }
    var filledCount: Int { get }
    var canBeReseted: Bool { get }
    
    func mainAction()
    func reset()
}

// MARK: - TimedPomodoroWorkerImpl

final class TimedPomodoroWorkerImpl: TimedPomodoroWorker {
    
    // MARK: - Public Properties
    
    private(set) var pomodoroState: CurrentValueSubject<PomodoroState, Never>
    private(set) var timerState: CurrentValueSubject<TimerState, Never>
    private(set) var leftTime: CurrentValueSubject<TimeInterval, Never>
    
    var formattedTime: String {
        dateComponentsFormatter.getFormattedTime(time: leftTime.value)
    }
    
    var stagesCount: Int {
        pomodoroService.stagesCount
    }
    
    var filledCount: Int {
        pomodoroService.completedStages
    }
    
    var canBeReseted: Bool {
        timerService.canBeReseted
    }
    
    // MARK: - Private Properties
    
    private let activityService: LiveActivityService
    private var pomodoroService: PomodoroService
    private var timerService: TimerService
    private let dateComponentsFormatter: DateComponentsFormatter = .minutesAndSecondsFormatter
    
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(
        activityService: LiveActivityService,
        pomodoroService: PomodoroService,
        timerService: TimerService
    ) {
        self.activityService = activityService
        self.pomodoroService = pomodoroService
        self.timerService = timerService
        
        self.pomodoroState = CurrentValueSubject<PomodoroState, Never>(pomodoroService.currentState)
        self.timerState = CurrentValueSubject<TimerState, Never>(timerService.currentState)
        self.leftTime = CurrentValueSubject<TimeInterval, Never>(pomodoroService.currentState.waitingTime)
        
        self.pomodoroService.delegate = self
        self.timerService.delegate = self
        
        addSubsctiptions()
    }
    
    // MARK: - Public Methods
    
    func mainAction() {
        switch timerState.value {
        case .initial:
            activityService.start(
                pomodoroState: pomodoroState.value,
                timerState: timerState.value,
                leftTime: formattedTime,
                stagesCount: stagesCount,
                filledCount: filledCount)
            timerService.start(waitingTime: pomodoroState.value.waitingTime)
        case .running:
            timerService.pause()
        case .ended:
            reset()
        case .paused:
            timerService.resume()
        }
    }
    
    func reset() {
        activityService.stop()
        pomodoroService.reset()
        timerService.reset()
        leftTime.send(pomodoroService.currentState.waitingTime)
    }
    
    // MARK: - Private Methods
    
    private func addSubsctiptions() {
        Publishers.CombineLatest3(
            pomodoroState,
            timerState,
            leftTime)
        .sink { [weak self] pomodoroState, timerState, leftTime in
            guard let self = self else { return }
            self.activityService.update(
                pomodoroState: pomodoroState,
                timerState: timerState,
                leftTime: self.dateComponentsFormatter.getFormattedTime(time: leftTime),
                filledCount: self.filledCount)
        }
        .store(in: &subscriptions)
    }
}

// MARK: - PomodoroServiceDelegate

extension TimedPomodoroWorkerImpl: PomodoroServiceDelegate {
    
    func pomododoService(_ service: PomodoroService, didChangeStateTo state: PomodoroState) {
        pomodoroState.send(state)
        guard !service.atInitialState else { return }
        timerService.start(waitingTime: pomodoroState.value.waitingTime)
    }
    
    func pomodoroServiceDidFinishCycle(_ service: PomodoroService) {
        timerService.stop()
    }
}

// MARK: - TimerServiceDelegate

extension TimedPomodoroWorkerImpl: TimerServiceDelegate {
    
    func timerService(_ service: TimerService, didChangeStateTo state: TimerState) {
        timerState.send(state)
    }
    
    func timerService(_ service: TimerService, didTickAtInterval interval: TimeInterval) {
        leftTime.send(interval)
    }
    
    func timerServiceDidFinish(_ service: TimerService) {
        pomodoroService.moveForward()
    }
}
