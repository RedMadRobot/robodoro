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
    private(set) var dailyAverageFocusValue: Double
    
    @Published
    private(set) var totalFocusValue: Double
    
    private(set) var feedbackService: FeedbackService
    
    public var shouldShowPreviousResults: Bool {
        guard let startOfWeek = dateCalculatorService.startOfWeek else { return false }
        let oldTasks = tasksStorage.getTasks(before: startOfWeek)
        return !oldTasks.isEmpty
    }
    
    // MARK: - Private Properties
        
    private let dateCalculatorService: DateCalculatorService
    
    private let tasksStorage: TasksStorage
    
    private var subscriptions = Set<AnyCancellable>()
    
    private var taskToDelete: PomodoroTask?
    
    // MARK: - Init
    
    init(
        dateCalculatorService: DateCalculatorService = DI.services.dateCalculatorService,
        tasksStorage: TasksStorage = DI.storages.taskStorage,
        feedbackService: FeedbackService = DI.services.feedbackService
    ) {
        self.dateCalculatorService = dateCalculatorService
        self.tasksStorage = tasksStorage
        self.feedbackService = feedbackService
        
        let allTasks = tasksStorage.tasks.value
        
        self.tasks = allTasks
        self.dailyAverageFocusValue = dateCalculatorService.calculateWeekDailyAverageFocusValue(tasks: allTasks)
        self.totalFocusValue = dateCalculatorService.calculateWeekTotalFocusValue(tasks: allTasks)
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
            self?.recalculateTime()
        }
        .store(in: &subscriptions)
    }
    
    private func recalculateTime() {
        dailyAverageFocusValue = dateCalculatorService.calculateWeekDailyAverageFocusValue(tasks: tasks)
        totalFocusValue = dateCalculatorService.calculateWeekTotalFocusValue(tasks: tasks)
    }
}
