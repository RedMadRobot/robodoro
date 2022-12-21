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
    var tasks: [PomodoroTask]
    
    @Published
    private(set) var showingAlert: Bool = false
    
    @Published
    private(set) var dailyAverageFocusValue: Int
    
    @Published
    private(set) var totalFocusValue: Int
    
    private(set) var feedbackService: FeedbackService
    
    // MARK: - Private Properties
    
    private var taskToDelete: PomodoroTask?
    
    private let timedPomodoroWorker: TimedPomodoroWorker
    
    // MARK: - Init
    
    init(
        timedPomodoroWorker: TimedPomodoroWorker = DI.workers.timedPomodoroWorker,
        feedbackService: FeedbackService = DI.services.feedbackService
    ) {
        self.timedPomodoroWorker = timedPomodoroWorker
        self.feedbackService = feedbackService
        
        self.tasks = Array(1...10).map {
            PomodoroTask(
                id: UUID(),
                title: "Task № \($0)",
                date: Date(),
                completedInterval: 60 * 5)
        }
        self.dailyAverageFocusValue = 30
        self.totalFocusValue = 210
    }
    
    // MARK: - Public Methods
    
    func deleteSelectedTask() {
        tasks.removeAll { $0 == taskToDelete }
        hideAlert()
    }
    
    func showAlert(taskToDelete: PomodoroTask) {
        self.taskToDelete = taskToDelete
        showingAlert = true
    }
    
    func hideAlert() {
        self.taskToDelete = nil
        showingAlert = false
    }
    
    // MARK: - Private Methods
}
