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
    var focusTimeValue: TimeInterval = 5 * 60
    
    @Published
    var breakTimeValue: TimeInterval = 6 * 60
    
    @Published
    var longBreakTimeValue: TimeInterval = 7 * 60
    
    private(set) var feedbackService: FeedbackService
    
    // MARK: - Private Properties
    
    private let timedPomodoroWorker: TimedPomodoroWorker
    
    // MARK: - Init
    
    init(
        timedPomodoroWorker: TimedPomodoroWorker = DI.workers.timedPomodoroWorker,
        feedbackService: FeedbackService = DI.services.feedbackService
    ) {
        self.timedPomodoroWorker = timedPomodoroWorker
        self.feedbackService = feedbackService
    }
    
    // MARK: - Public Methods
    
    func applyParameters() {
        timedPomodoroWorker.setup(
            stages: 2,
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
    
}
