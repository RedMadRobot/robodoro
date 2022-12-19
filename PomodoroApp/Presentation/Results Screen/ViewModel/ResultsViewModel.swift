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
    
    @Published
    private(set) var tasks: [PomodoroTask]
    
    @Published
    private(set) var dailyAverageFocusValue: Int
    
    @Published
    private(set) var totalFocusValue: Int
    
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
        
        self.tasks = [
            PomodoroTask(
                id: UUID(),
                title: "Some task",
                date: Date(),
                completedInterval: 60 * 5)
        ]
        self.dailyAverageFocusValue = 30
        self.totalFocusValue = 210
    }
    
    // MARK: - Public Methods
    
    // MARK: - Private Methods
    
}
