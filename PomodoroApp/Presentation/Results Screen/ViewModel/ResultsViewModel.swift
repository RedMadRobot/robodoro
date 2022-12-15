//
//  ResultsViewModel.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 12.12.2022.
//

import Combine
import SwiftUI

final class ResultsViewModel: ViewModel {
    
    // MARK: - Public Properties
    
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
    
    func prepareToStartPomodoro() {
        timedPomodoroWorker.setup(
            stages: 1,
            intervals: { stage in
                switch stage {
                case .focus:
                    return 10
                case .break:
                    return 5
                case .longBreak:
                    return 10
                }
            })
    }
    
    // MARK: - Private Methods
    
}
