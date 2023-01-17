//
//  PreviousResultsViewModel.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 17.01.2023.
//

import SwiftUI

final class PreviousResultsViewModel: ViewModel {
    
    // MARK: - Public Properties
    
    private(set) var tasks: [PomodoroTask]
    
    private(set) var dailyAverageFocusValue: Double
    
    private(set) var totalFocusValue: Double
    
    private(set) var feedbackService: FeedbackService
    
    // MARK: - Private Properties
    
    private let dateCalculatorService: DateCalculatorService
    private let tasksStorage: TasksStorage
    
    // MARK: - Init
    
    init(
        dateCalculatorService: DateCalculatorService = DI.services.dateCalculatorService,
        tasksStorage: TasksStorage = DI.storages.taskStorage,
        feedbackService: FeedbackService = DI.services.feedbackService
    ) {
        self.dateCalculatorService = dateCalculatorService
        self.tasksStorage = tasksStorage
        self.feedbackService = feedbackService
        
        guard let startOfWeek = dateCalculatorService.startOfWeek else {
            self.tasks = []
            self.dailyAverageFocusValue = 0
            self.totalFocusValue = 0
            return
        }
        
        let previousTasks = tasksStorage.getTasks(before: startOfWeek)
        
        self.tasks = previousTasks
        self.dailyAverageFocusValue = dateCalculatorService.calculatePreviousWeekDailyAverageFocusValue(tasks: previousTasks)
        self.totalFocusValue = dateCalculatorService.calculatePreviousWeekTotalFocusValue(tasks: tasks)
    }
    
    // MARK: - Public Methods
    
    func clearOldTasks() {
        guard let startOfWeek = dateCalculatorService.startOfWeek else { return }
        tasksStorage.deleteTasks(before: startOfWeek)
    }
}
