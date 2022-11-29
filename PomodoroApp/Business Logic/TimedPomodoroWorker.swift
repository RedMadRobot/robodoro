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
    var enterForegroundAction: LinkManager.Action? { get }
    
    func mainAction()
    func reset()
    func setLinkAction(_ action: LinkManager.Action)
    func handleLinkAction(_ action: LinkManager.Action)
    func handleEnterBackground()
    func handleEnterForeground()
    func requestNotificationPermissionIfNeeded()
    func cancelNotification()
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
        timerService.canBeReseted || !pomodoroService.atInitialState
    }
    
    var enterForegroundAction: LinkManager.Action?
    
    // MARK: - Private Properties
    
    private let activityService: LiveActivityService
    private let feedbackService: FeedbackService
    private let notificationService: NotificationService
    private var pomodoroService: PomodoroService
    private var timerService: TimerService
    
    private var subscriptions = Set<AnyCancellable>()
    
    private var backgroundDate: Date?
    
    // MARK: - Init
    
    init(
        activityService: LiveActivityService,
        feedbackService: FeedbackService,
        notificationService: NotificationService,
        pomodoroService: PomodoroService,
        timerService: TimerService
    ) {
        self.activityService = activityService
        self.feedbackService = feedbackService
        self.notificationService = notificationService
        self.pomodoroService = pomodoroService
        self.timerService = timerService
        
        self.pomodoroState = CurrentValueSubject<PomodoroState, Never>(pomodoroService.currentState)
        self.timerState = CurrentValueSubject<TimerState, Never>(timerService.currentState)
        self.leftTime = CurrentValueSubject<TimeInterval, Never>(pomodoroService.currentState.waitingTime)
        
        self.pomodoroService.delegate = self
        self.timerService.delegate = self
        
        timerService.reset(waitingTime: pomodoroService.currentState.waitingTime)
        
        addSubsctiptions()
    }
    
    // MARK: - Public Methods
    
    func mainAction() {
        switch timerState.value {
        case .initial:
            activityService.start(
                pomodoroState: pomodoroState.value,
                timerState: timerState.value,
                stageEndDate: Date.now.addingTimeInterval(leftTime.value),
                stagesCount: stagesCount,
                filledCount: filledCount)
            timerService.start()
            scheduleCurrentStateNotification()
        case .running:
            timerService.pause()
            cancelNotification()
        case .ended:
            reset()
        case .paused:
            timerService.resume()
            scheduleCurrentStateNotification()
        }
    }
    
    func reset() {
        activityService.stop()
        pomodoroService.reset()
        timerService.reset(waitingTime: pomodoroService.currentState.waitingTime)
        cancelNotification()
    }
    
    func setLinkAction(_ action: LinkManager.Action) {
        enterForegroundAction = action
    }
    
    func handleLinkAction(_ action: LinkManager.Action) {
        switch (action, timerState.value) {
        case (.start, .initial), (.start, .paused),
             (.stop, .ended),
             (.pause, .running):
            mainAction()
        default:
            break
        }
    }
    
    func handleEnterBackground() {
        // Зафиксировать дату перехода в фоновый режим
        backgroundDate = Date.now
        
        // Остановить работу таймера без изменения состояния
        timerService.suspend()
    }
    
    func handleEnterForeground() {
        defer {
            backgroundDate = nil
            handleLinkActionIfNeeded()
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
            timerService.reset(waitingTime: currentWaitingTime)
            timerService.start()
        }
    }
    
    func requestNotificationPermissionIfNeeded() {
        notificationService.requestPermissionIfNeeded()
    }
    
    func cancelNotification() {
        notificationService.cancelPendingNotification()
    }
    
    // MARK: - Private Methods
    
    private func addSubsctiptions() {
        Publishers.CombineLatest(
            pomodoroState,
            timerState)
        .sink { [weak self] pomodoroState, timerState in
            guard let self = self else { return }
            self.activityService.update(
                pomodoroState: pomodoroState,
                timerState: timerState,
                stageEndDate: Date.now.addingTimeInterval(self.leftTime.value),
                filledCount: self.filledCount)
        }
        .store(in: &subscriptions)
    }
    
    private func handleLinkActionIfNeeded() {
        guard let action = enterForegroundAction else { return }
        handleLinkAction(action)
        enterForegroundAction = nil
    }
    
    private func scheduleCurrentStateNotification() {
        notificationService.scheduleNotification(
            in: leftTime.value,
            title: "\(pomodoroState.value.title) stage ended!",
            body: "Get ready to start new timer")
    }
}

// MARK: - PomodoroServiceDelegate

extension TimedPomodoroWorkerImpl: PomodoroServiceDelegate {
    
    func pomododoService(_ service: PomodoroService, didChangeStateTo state: PomodoroState) {
        pomodoroState.send(state)
        timerService.reset(waitingTime: state.waitingTime)
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
        feedbackService.playTimerEndSignal()
        pomodoroService.moveForward()
    }
}
