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
    var tasks: [PomodoroTask] {
        didSet {
            recalculateTime()
        }
    }
    
    @Published
    private(set) var dailyAverageFocusValue: Double
    
    @Published
    private(set) var totalFocusValue: Double
    
    private(set) var feedbackService: FeedbackService
    
    // MARK: - Private Properties
    
    private var taskToDelete: PomodoroTask?
        
    private let focusedTimeCalculatorService: FocusedTimeCalculatorService
    
    private let tasksStorage: TasksStorage
    
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(
        focusedTimeCalculatorService: FocusedTimeCalculatorService = DI.services.focusedTimeCalculatorService,
        tasksStorage: TasksStorage = DI.storages.taskStorage,
        feedbackService: FeedbackService = DI.services.feedbackService
    ) {
        self.focusedTimeCalculatorService = focusedTimeCalculatorService
        self.tasksStorage = tasksStorage
        self.feedbackService = feedbackService
        
        let allTasks = tasksStorage.tasks.value
        
        self.tasks = allTasks
        self.dailyAverageFocusValue = focusedTimeCalculatorService.calculateWeekDailyAverageFocusValue(tasks: allTasks)
        self.totalFocusValue = focusedTimeCalculatorService.calculateWeekTotalFocusValue(tasks: allTasks)
        addSubscriptions()
    }
    
    // MARK: - Public Methods
    
    func prepareToDeleteTask(task: PomodoroTask) {
        taskToDelete = task
    }
    
    func deleteSelectedTask() {
        guard let taskToDelete = taskToDelete else { return }
        tasksStorage.deleteTask(withId: taskToDelete.id)
        self.taskToDelete = nil
    }
    
    // MARK: - Private Methods
    
    private func addSubscriptions() {
        tasksStorage.tasks.sink { [weak self] tasks in
            self?.tasks = tasks
        }
        .store(in: &subscriptions)
    }
    
    private func recalculateTime() {
        dailyAverageFocusValue = focusedTimeCalculatorService.calculateWeekDailyAverageFocusValue(tasks: tasks)
        totalFocusValue = focusedTimeCalculatorService.calculateWeekTotalFocusValue(tasks: tasks)
    }
}
