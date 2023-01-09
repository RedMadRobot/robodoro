//
//  PomodoroViewModel.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 11.11.2022.
//

import Combine
import SwiftUI

final class PomodoroViewModel: ViewModel {

    // MARK: - Public Properties
    
    @Published
    private(set) var pomodoroState: PomodoroState
    
    @Published
    private(set) var timerState: TimerState
    
    @Published
    private(set) var leftTime: TimeInterval
    
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
    
    private(set) var feedbackService: FeedbackService
    
    // MARK: - Private Propeties
    
    private let timedPomodoroWorker: TimedPomodoroWorker
    
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Init
  
    init(
        timedPomodoroWorker: TimedPomodoroWorker = DI.workers.timedPomodoroWorker,
        feedbackService: FeedbackService = DI.services.feedbackService
    ) {
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
    
    private func formattedTimeComponent(_ component: Int) -> String {
        String(format: "%0.2d", component)
    }
}
