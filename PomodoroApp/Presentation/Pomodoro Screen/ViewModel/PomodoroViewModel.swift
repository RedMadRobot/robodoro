//
//  PomodoroViewModel.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 11.11.2022.
//

import Combine
import Nivelir
import SwiftUI

final class PomodoroViewModel: ViewModel {

    // MARK: - Private Propeties
    
    private let navigator: ScreenNavigator
    private let screens: Screens
    
    private let timedPomodoroWorker: TimedPomodoroWorker
    
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Public Properties
    
    @Published
    private(set) var pomodoroState: PomodoroState
    
    @Published
    private(set) var timerState: TimerState
    
    @Published
    private(set) var leftTime: TimeInterval
    
    @Published
    private(set) var alertState: AlertState = .noAlert
    
    var minutes: String {
        formattedTimeComponent(leftTime.minutesIgnoringHours)
    }
    
    var seconds: String {
        formattedTimeComponent(leftTime.seconds)
    }
    
    var maxStagesCount: Int {
        timedPomodoroWorker.maxStagesCount
    }
    
    var activeStagesCount: Int {
        timedPomodoroWorker.activeStagesCount
    }
    
    var lastStageState: StageElementViewState {
        timedPomodoroWorker.lastStageState
    }
    
    var backgroundColor: Color {
        ColorHelper.getBackgroundColor(
            pomodoroState: pomodoroState,
            timerState: timerState)
    }
    
    var strokeColor: Color {
        ColorHelper.getStrokeColor(
            pomodoroState: pomodoroState,
            timerState: timerState)
    }
    
    var buttonImage: Image {
        timerState.buttonImage
    }
    
    private(set) var feedbackService: FeedbackService
    
    // MARK: - Init
  
    init(
        navigator: ScreenNavigator,
        screens: Screens,
        timedPomodoroWorker: TimedPomodoroWorker = DI.workers.timedPomodoroWorker,
        feedbackService: FeedbackService = DI.services.feedbackService
    ) {
        self.navigator = navigator
        self.screens = screens
        self.timedPomodoroWorker = timedPomodoroWorker
        self.feedbackService = feedbackService
        
        self.pomodoroState = timedPomodoroWorker.pomodoroState.value
        self.timerState = timedPomodoroWorker.timerState.value
        self.leftTime = timedPomodoroWorker.leftTime.value
        
        addSubscriptions()
    }
    
    // MARK: - Public Methods
    
    func mainButtonAction() {
        performImpact()
        timedPomodoroWorker.mainAction()
    }
    
    func resetWorker() {
        timedPomodoroWorker.reset()
    }
    
    func endTaskTapped() {
        let alertViewModel = AlertViewModel(
            title: Strings.PomodoroScreen.EndTaskAlert.title,
            primaryButtonTitle: Strings.PomodoroScreen.EndTaskAlert.primaryAction,
            secondaryButtonTitle: Strings.PomodoroScreen.EndTaskAlert.secondaryAction,
            primaryAction: resetTimerAndHideScreen,
            commonCompletion: { [weak self] in
                self?.alertState = .noAlert
            }
        )
        
        alertState = .presenting(alertViewModel)
    }
    
    func hideScreen() {
        navigator.navigate { route in
            route
                .top(.container)
                .presenting
                .dismiss()
        }
    }
    
    // MARK: - Private Methods
    
    private func addSubscriptions() {
        Publishers.CombineLatest3(
            timedPomodoroWorker.pomodoroState,
            timedPomodoroWorker.timerState,
            timedPomodoroWorker.leftTime)
        .sink { [weak self] pomodoroState, timerState, leftTime in
            self?.pomodoroState = pomodoroState
            self?.timerState = timerState
            self?.leftTime = leftTime
        }
        .store(in: &subscriptions)
    }
    
    private func resetTimerAndHideScreen() {
        timedPomodoroWorker.reset()
        hideScreen()
    }
    
    private func formattedTimeComponent(_ component: Int) -> String {
        String(format: "%0.2d", component)
    }
}
