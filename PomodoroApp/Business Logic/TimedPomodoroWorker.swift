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
    
    var stagesCount: Int { get }
    var filledCount: Int { get }
    var canBeReseted: Bool { get }
    var isPomodoroFinished: Bool { get }
    
    func mainAction()
    func reset()
    func handleEnterBackground()
    func handleEnterForeground()
}

// MARK: - TimedPomodoroWorkerImpl

final class TimedPomodoroWorkerImpl: TimedPomodoroWorker {
    
    // MARK: - Public Properties
    
    private(set) var pomodoroState: CurrentValueSubject<PomodoroState, Never>
    private(set) var timerState: CurrentValueSubject<TimerState, Never>
    private(set) var leftTime: CurrentValueSubject<TimeInterval, Never>
    
    var stagesCount: Int {
        pomodoroService.stagesCount
    }
    
    var filledCount: Int {
        pomodoroService.completedStages
    }
    
    var canBeReseted: Bool {
        timerService.canBeReseted
    }
    
    var isPomodoroFinished: Bool {
        pomodoroService.isFinished
    }
    
    // MARK: - Private Properties
    
    private let activityService: LiveActivityService
    private var pomodoroService: PomodoroService
    private var timerService: TimerService
    
    private var subscriptions = Set<AnyCancellable>()
    
    private var backgroundDate: Date?
    
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
//            activityService.start(
//                pomodoroState: pomodoroState.value,
//                timerState: timerState.value,
//                stageEndDate: Date.now.addingTimeInterval(leftTime.value),
//                stagesCount: stagesCount,
//                filledCount: filledCount,
//                isPomodoroFinished: isPomodoroFinished)
            timerService.start(waitingTime: pomodoroState.value.waitingTime)
        case .running:
            timerService.pause()
        case .ended:
            if pomodoroService.isFinished {
                reset()
            } else {
                timerService.start(waitingTime: pomodoroState.value.waitingTime)
            }
        case .paused:
            timerService.resume()
        }
    }
    
    func reset() {
//        activityService.stop()
        pomodoroService.reset()
        timerService.reset()
        leftTime.send(pomodoroService.currentState.waitingTime)
    }
    
    func handleEnterBackground() {
        // Зафиксировать дату перехода в фоновый режим
        backgroundDate = Date.now
        
        // Остановить работу таймера без изменения состояния
        timerService.suspend()
    }
    
    func handleEnterForeground() {
        defer {
            self.backgroundDate = nil
        }
        
        // Если последняя дата зафиксированна и таймер в состоянии .running
        guard let backgroundDate = backgroundDate,
              timerState.value == .running else { return }
        
        let currentInterval = pomodoroState.value.waitingTime
        
        // Посчитать количество секунд между текущей датой и последней зафиксированной
        // Прибавляем к этому числу число уже пройденное время текущего этапа
        let difference = Calendar.current.dateComponents([.second], from: backgroundDate, to: Date.now)
        let seconds = TimeInterval(difference.second!) + (currentInterval - leftTime.value)
        
        // Отнять от последнего отсчета необходимое количество времени и продолжить выполнение, если требуется
        let currentWaitingTime: TimeInterval = currentInterval - seconds
        
        if currentWaitingTime < 0 {
            timerService.stop()
            pomodoroService.moveForward()
        } else {
            timerService.start(waitingTime: currentWaitingTime)
        }
    }
    
    // MARK: - Private Methods
    
    private func addSubsctiptions() {
//        Publishers.CombineLatest(
//            pomodoroState,
//            timerState)
//        .sink { [weak self] pomodoroState, timerState in
//            guard let self = self else { return }
//            self.activityService.update(
//                pomodoroState: pomodoroState,
//                timerState: timerState,
//                stageEndDate: Date.now.addingTimeInterval(self.leftTime.value),
//                filledCount: self.filledCount,
//                isPomodoroFinished: self.isPomodoroFinished)
//        }
//        .store(in: &subscriptions)
    }
}

// MARK: - PomodoroServiceDelegate

extension TimedPomodoroWorkerImpl: PomodoroServiceDelegate {
    
    func pomododoService(_ service: PomodoroService, didChangeStateTo state: PomodoroState) {
        leftTime.send(pomodoroState.value.waitingTime)
        pomodoroState.send(state)
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
