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
    var currentTaskId: UUID? { get }
    
    func setup(
        taskName: String?,
        stages: Int,
        intervals: @escaping (PomodoroState) -> TimeInterval)
    func setup(savedData: AppReloadSavedData)
    func mainAction()
    func reset()
    func setLinkAction(_ action: LinkManager.Action)
    func handleLinkAction(_ action: LinkManager.Action, navigator: MainNavigator)
    func handleEnterBackground()
    func handleEnterForeground(navigator: MainNavigator)
    func requestNotificationPermissionIfNeeded()
    func stopActivityIfNeeded()
    func cancelNotification()
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
    
    private(set) var currentTaskId: UUID?
    
    // MARK: - Private Properties
    
    private let activityService: LiveActivityService
    private let feedbackService: FeedbackService
    private let notificationService: NotificationService
    private var pomodoroService: PomodoroService
    private var timerService: TimerService
    
    private var userDefaultsStorage: SaveStateStorage
    private let tasksStorage: TasksStorage
    
    private var subscriptions = Set<AnyCancellable>()
    
    private var customIntervals: ((PomodoroState) -> TimeInterval)?
    private var currentStagePassedTime: TimeInterval?
    private var settedUp = false
    
    // MARK: - Init
    
    init(
        activityService: LiveActivityService,
        feedbackService: FeedbackService,
        notificationService: NotificationService,
        pomodoroService: PomodoroService,
        timerService: TimerService,
        userDefaultsStorage: SaveStateStorage,
        tasksStorage: TasksStorage
    ) {
        self.activityService = activityService
        self.feedbackService = feedbackService
        self.notificationService = notificationService
        self.pomodoroService = pomodoroService
        self.timerService = timerService
        self.userDefaultsStorage = userDefaultsStorage
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
        customIntervals = intervals
        timerService.reset(waitingTime: interval(for: pomodoroService.currentState))
        currentTaskId = tasksStorage.createTask(withTitle: taskName).id
        currentStagePassedTime = 0
        settedUp = true
    }
    
    func setup(savedData: AppReloadSavedData) {
        pomodoroService.setup(savedData: savedData.pomodoroServiceSavedData)
        customIntervals = { (state) in
            switch state {
            case .focus:
                return savedData.focusTime
            case .break:
                return savedData.breakTime
            case .longBreak:
                return savedData.longBreakTime
            }
        }
        
        currentTaskId = savedData.taskId
        currentStagePassedTime = interval(for: pomodoroService.currentState) - savedData.leftTime
        
        timerService.reset(waitingTime: savedData.leftTime)
        
        if let backgroundDate = savedData.backgroundDate {
            let currentInterval = interval(for: pomodoroService.currentState)
            
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
        
        userDefaultsStorage.appReloadSavedData = nil
        settedUp = true
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
        case .paused:
            timerService.resume()
            scheduleCurrentStateNotification()
        default:
            break
        }
    }
    
    func reset() {
        activityService.stop()
        pomodoroService.reset()
        cancelNotification()
        currentTaskId = nil
        currentStagePassedTime = nil
        settedUp = false
    }
    
    func setLinkAction(_ action: LinkManager.Action) {
        enterForegroundAction = action
    }
    
    func handleLinkAction(_ action: LinkManager.Action, navigator: MainNavigator) {
        switch (action, timerState.value) {
        case (.start, .initial),
             (.start, .paused),
             (.pause, .running):
            mainAction()
        case (.stop, .ended):
            reset()
            navigator.hidePomodoroModal()
        default:
            break
        }
    }
    
    func handleEnterBackground() {
        guard let _ = currentTaskId  else { return }
        saveState()
        timerService.suspend()
    }
    
    func handleEnterForeground(navigator: MainNavigator) {
        guard let savedData = userDefaultsStorage.appReloadSavedData else { return }
        setup(savedData: savedData)
        handleLinkActionIfNeeded(navigator: navigator)
    }
    
    func requestNotificationPermissionIfNeeded() {
        notificationService.requestPermissionIfNeeded()
    }
    
    func stopActivityIfNeeded() {
        guard !settedUp else { return }
        stopActivity()
    }
    
    func cancelNotification() {
        notificationService.cancelPendingNotification()
    }
    
    func saveState() {
        guard let currentTaskId else { return }

        var backgroundDate: Date?
        if timerState.value == .running || timerState.value == .ended {
            backgroundDate = Date.now
        }
        
        let data = AppReloadSavedData(
            backgroundDate: backgroundDate,
            taskId: currentTaskId,
            leftTime: leftTime.value,
            focusTime: interval(for: .focus),
            breakTime: interval(for: .break),
            longBreakTime: interval(for: .longBreak),
            pomodoroServiceSavedData: pomodoroService.dataToSave)
        userDefaultsStorage.appReloadSavedData = data
        
        print("DATA SAVED")
    }
    
    // MARK: - Private Methods
    
    private func addSubscriptions() {
        Publishers.CombineLatest(
            pomodoroState,
            timerState)
        .sink { [weak self] pomodoroState, timerState in
            guard let self else { return }
            self.activityService.update(
                pomodoroState: pomodoroState,
                timerState: timerState,
                stageEndDate: Date.now.addingTimeInterval(self.leftTime.value),
                activeStagesCount: self.activeStagesCount,
                lastStageState: self.lastStageState)
        }
        .store(in: &subscriptions)
        
        leftTime.sink { [weak self] value in
            guard let self else { return }
            self.updateManagingTaskIntervalIfNeeded()
        }
        .store(in: &subscriptions)
    }
    
    private func handleLinkActionIfNeeded(navigator: MainNavigator) {
        guard let action = enterForegroundAction else { return }
        handleLinkAction(action, navigator: navigator)
        enterForegroundAction = nil
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
    
    private func interval(for state: PomodoroState) -> TimeInterval {
        customIntervals?(state) ?? state.defaultWaitingTime
    }
    
    private func scheduleCurrentStateNotification() {
        notificationService.scheduleNotification(
            in: leftTime.value,
            title: Strings.Notification.StageEnded.title(pomodoroState.value.title),
            body: Strings.Notification.StageEnded.body
        )
    }
    
    private func stopActivity() {
        activityService.stop()
    }
}

// MARK: - PomodoroServiceDelegate

extension TimedPomodoroWorkerImpl: PomodoroServiceDelegate {
    
    func pomodoroService(_ service: PomodoroService, didChangeStateTo state: PomodoroState) {
        currentStagePassedTime = 0
        pomodoroState.send(state)
        timerService.reset(waitingTime: interval(for: state))
    }
    
    func pomodoroServiceEnded(_ service: PomodoroService) {
        timerService.stop()
        stopActivity()
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
