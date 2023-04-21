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
    private(set) var taskItems: [PomodoroTaskItem]
    
    @Published
    private(set) var dailyAverageFocusValue: Double
    
    @Published
    private(set) var totalFocusValue: Double
    
    @Published
    private(set) var showDeletionOnboarding: Bool
    
    private(set) var feedbackService: FeedbackService
    
    // MARK: - Private Properties
        
    private let dateCalculatorService: DateCalculatorService
    private let tasksStorage: TasksStorage
    private var userDefaultsStorage: OnboardingStorage
    
    private var subscriptions = Set<AnyCancellable>()
    
    private var taskToDelete: PomodoroTaskItem?
    
    // MARK: - Init
    
    init(
        dateCalculatorService: DateCalculatorService = DI.services.dateCalculatorService,
        tasksStorage: TasksStorage = DI.storages.taskStorage,
        userDefaultsStorage: OnboardingStorage = DI.storages.userDefaultsStorage,
        feedbackService: FeedbackService = DI.services.feedbackService
    ) {
        self.dateCalculatorService = dateCalculatorService
        self.tasksStorage = tasksStorage
        self.userDefaultsStorage = userDefaultsStorage
        self.feedbackService = feedbackService
        self.showDeletionOnboarding = !userDefaultsStorage.deleteFeatureUsed
        
        let allTasks = tasksStorage.tasks.value
        
        self.taskItems = allTasks.map { PomodoroTaskItem(task: $0) }
        self.dailyAverageFocusValue = dateCalculatorService.calculateCurrentWeekDailyAverageFocusValue(tasks: allTasks)
        self.totalFocusValue = dateCalculatorService.calculateCurrentWeekTotalFocusValue(tasks: allTasks)
        addSubscriptions()
    }
    
    // MARK: - Public Methods
    
    func prepareToDeleteTask(task: PomodoroTaskItem) {
        taskToDelete = task
    }
    
    func deleteSelectedTask() {
        guard let taskToDelete else { return }
        tasksStorage.deleteTask(withId: taskToDelete.id)
        self.taskToDelete = nil
        userDefaultsStorage.deleteFeatureUsed = true
        showDeletionOnboarding = false
    }
    
    // MARK: - Private Methods
    
    private func addSubscriptions() {
        tasksStorage.tasks.sink { [weak self] tasks in
            self?.taskItems = tasks.map { PomodoroTaskItem(task: $0) }
            self?.recalculateTime(tasks: tasks)
        }
        .store(in: &subscriptions)
    }
    
    private func recalculateTime(tasks: [PomodoroTask]) {
        dailyAverageFocusValue = dateCalculatorService.calculateCurrentWeekDailyAverageFocusValue(tasks: tasks)
        totalFocusValue = dateCalculatorService.calculateCurrentWeekTotalFocusValue(tasks: tasks)
    }
}
