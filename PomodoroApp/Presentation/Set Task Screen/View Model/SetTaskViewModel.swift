//
//  SetTaskViewModel.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 15.12.2022.
//

import Combine
import SwiftUI

final class SetTaskViewModel: ViewModel {
    
    // MARK: - Public Properties
    
    @Published
    var focusTimeValue: TimeInterval
    
    @Published
    var breakTimeValue: TimeInterval
    
    @Published
    var longBreakTimeValue: TimeInterval
    
    @Published
    var stagesCount: Int
    
    @Published
    var taskTitle: String = ""
    
    private(set) var feedbackService: FeedbackService
    
    // MARK: - Private Properties
    
    private let timedPomodoroWorker: TimedPomodoroWorker
    private var userDefaultsStorage: LastUsedValuesStorage
    
    // MARK: - Init
    
    init(
        timedPomodoroWorker: TimedPomodoroWorker = DI.workers.timedPomodoroWorker,
        userDefaultsStorage: LastUsedValuesStorage = DI.storages.userDefaultsStorage,
        feedbackService: FeedbackService = DI.services.feedbackService
    ) {
        self.timedPomodoroWorker = timedPomodoroWorker
        self.userDefaultsStorage = userDefaultsStorage
        self.feedbackService = feedbackService
        
        self.focusTimeValue = userDefaultsStorage.lastFocusTime
        self.breakTimeValue = userDefaultsStorage.lastBreakTime
        self.longBreakTimeValue = userDefaultsStorage.lastLongBreakTime
        self.stagesCount = userDefaultsStorage.lastStagesCount
    }
    
    // MARK: - Public Methods
    
    func applyParameters() {
        saveLastValues()
        timedPomodoroWorker.setup(
            stages: stagesCount,
            intervals: { [weak self] stage in
                guard let self = self else { return stage.defaultWaitingTime }
                switch stage {
                case .focus:
                    return self.focusTimeValue
                case .break:
                    return self.breakTimeValue
                case .longBreak:
                    return self.longBreakTimeValue
                }
            })
    }
    
    // MARK: - Private Methods
    
    private func saveLastValues() {
        userDefaultsStorage.lastFocusTime = focusTimeValue
        userDefaultsStorage.lastBreakTime = breakTimeValue
        userDefaultsStorage.lastLongBreakTime = longBreakTimeValue
        userDefaultsStorage.lastStagesCount = stagesCount
    }
}
