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
    
    var maxStagesCount: Int { get }
    var activeStagesCount: Int { get }
    var lastStageState: StageElementViewState { get }
    var enterForegroundAction: LinkManager.Action? { get }
    
    func setup(
        taskName: String?,
        stages: Int,
        intervals: @escaping (PomodoroState) -> TimeInterval)
    func mainAction()
    func reset()
    func setLinkAction(_ action: LinkManager.Action)
    func handleLinkAction(_ action: LinkManager.Action)
    func handleEnterBackground()
    func handleEnterForeground()
    func requestNotificationPermissionIfNeeded()
    func cancelNotification()
    func saveState()
}

// MARK: - TimedPomodoroWorkerImpl

final class TimedPomodoroWorkerImpl: TimedPomodoroWorker {
    
    // MARK: - Public Properties
    
    private(set) var pomodoroState: CurrentValueSubject<PomodoroState, Never>
    private(set) var timerState: CurrentValueSubject<TimerState, Never>
    private(set) var leftTime: CurrentValueSubject<TimeInterval, Never>
    
    var maxStagesCount: Int {
        pomodoroService.stagesCount
    }
    
    var activeStagesCount: Int {
        pomodoroService.completedStages
    }
    
    var lastStageState: StageElementViewState {
        if pomodoroService.atLastStateOfCurrentStage {
            return .filled
        }
        if case .initial = timerState.value {
            return .empty
        }
        else {
            return .half
        }
    }
    
    var enterForegroundAction: LinkManager.Action?
    
    // MARK: - Private Properties
    
    private let activityService: LiveActivityService
    private let feedbackService: FeedbackService
    private let notificationService: NotificationService
    private var pomodoroService: PomodoroService
    private var timerService: TimerService
    
    private let tasksStorage: TasksStorage
    
    private var subscriptions = Set<AnyCancellable>()
    
    private var backgroundDate: Date?
    
    private var customIntervals: ((PomodoroState) -> TimeInterval)?
    
    private var currentTaskId: UUID?
    private var currentStagePassedTime: TimeInterval?
    
    // MARK: - Init
    
    init(
        activityService: LiveActivityService,
        feedbackService: FeedbackService,
        notificationService: NotificationService,
        pomodoroService: PomodoroService,
        timerService: TimerService,
        tasksStorage: TasksStorage
    ) {
        self.activityService = activityService
        self.feedbackService = feedbackService
        self.notificationService = notificationService
        self.pomodoroService = pomodoroService
        self.timerService = timerService
        self.tasksStorage = tasksStorage
        
        self.pomodoroState = CurrentValueSubject<PomodoroState, Never>(pomodoroService.currentState)
        self.timerState = CurrentValueSubject<TimerState, Never>(timerService.currentState)
        self.leftTime = CurrentValueSubject<TimeInterval, Never>(pomodoroService.currentState.defaultWaitingTime)
        
        self.pomodoroService.delegate = self
        self.timerService.delegate = self
        
        timerService.reset(waitingTime: pomodoroService.currentState.defaultWaitingTime)
        
        addSubscriptions()
    }
    
    // MARK: - Public Methods
    
    func setup(
        taskName: String?,
        stages: Int,
        intervals: @escaping (PomodoroState) -> TimeInterval
    ) {
        pomodoroService.setup(stages: stages)
        self.customIntervals = intervals
        timerService.reset(waitingTime: interval(for: pomodoroService.currentState))
        
        currentTaskId = tasksStorage.createTask(withTitle: taskName).id
        currentStagePassedTime = 0
    }
    
    func mainAction() {
        switch timerState.value {
        case .initial:
            activityService.start(
                pomodoroState: pomodoroState.value,
                timerState: timerState.value,
                stageEndDate: Date.now.addingTimeInterval(leftTime.value),
                maxStagesCount: maxStagesCount,
                activeStagesCount: activeStagesCount,
                lastStageState: lastStageState)
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
        timerService.reset(waitingTime: interval(for: pomodoroService.currentState))
        cancelNotification()
        currentTaskId = nil
        currentStagePassedTime = nil
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
        
        let currentInterval = interval(for: pomodoroState.value)
        
        // Посчитать количество секунд между текущей датой и последней зафиксированной
        // Прибавляем к этому числу число уже пройденное время текущего этапа
        let difference = Calendar.current.dateComponents([.second], from: backgroundDate, to: Date.now)
        let seconds = TimeInterval(difference.second!) + (currentInterval - leftTime.value)
        
        // Отнять от последнего отсчета необходимое количество времени и продолжить выполнение, если требуется
        let currentWaitingTime: TimeInterval = currentInterval - seconds
        
        if currentWaitingTime < 0 {
            leftTime.send(0)
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
    
    func saveState() {
        // TODO: - Сохранить последнее состояние
    }
    
    // MARK: - Private Methods
    
    private func addSubscriptions() {
        Publishers.CombineLatest(
            pomodoroState,
            timerState)
        .sink { [weak self] pomodoroState, timerState in
            guard let self = self else { return }
            self.activityService.update(
                pomodoroState: pomodoroState,
                timerState: timerState,
                stageEndDate: Date.now.addingTimeInterval(self.leftTime.value),
                activeStagesCount: self.activeStagesCount,
                lastStageState: self.lastStageState)
        }
        .store(in: &subscriptions)
        
        leftTime.sink { [weak self] value in
            guard let self = self else { return }
            self.updateManagingTaskIntervalIfNeeded()
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
    
    private func interval(for state: PomodoroState) -> TimeInterval {
        customIntervals?(state) ?? state.defaultWaitingTime
    }
    
    private func updateManagingTaskIntervalIfNeeded() {
        guard let currentTaskId = currentTaskId,
              let currentStagePassedTime = currentStagePassedTime,
              pomodoroState.value == .focus else { return }
        
        let newStagePassedTime = interval(for: pomodoroState.value) - leftTime.value
        
        if currentStagePassedTime.minutesIgnoringHours < newStagePassedTime.minutesIgnoringHours {
            let newCompletedTime = newStagePassedTime + interval(for: pomodoroState.value) * Double(pomodoroService.completedStages)
            tasksStorage.updateTime(ofTaskWithId: currentTaskId, newTime: newCompletedTime)
            self.currentStagePassedTime = newStagePassedTime
        }
    }
}

// MARK: - PomodoroServiceDelegate

extension TimedPomodoroWorkerImpl: PomodoroServiceDelegate {
    
    func pomododoService(_ service: PomodoroService, didChangeStateTo state: PomodoroState) {
        currentStagePassedTime = 0
        pomodoroState.send(state)
        timerService.reset(waitingTime: interval(for: state))
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
