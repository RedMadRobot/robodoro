//
//  DebugPanelViewModel.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 16.02.2023.
//

import Combine
import SwiftUI

final class DebugPanelViewModel: ViewModel {
    
    // MARK: - Constants
    
    private enum Constants {
        static let maxTitleLength = 10
    }
    
    // MARK: - Public Properties
    
    @Published
    var taskTitle: String = ""
    
    @Published
    var taskDate: Date = Date.now
    
    @Published
    var taskCompletedInterval: TimeInterval = 0
    
    @Published
    private(set) var totalTasksCount: Int
    
    @Published
    var shrinkSlidersStep: Bool {
        didSet {
            userDefaultsStorage.shrinkSlidersStep = shrinkSlidersStep
            performImpact()
        }
    }
    
    private(set) var feedbackService: FeedbackService
    
    // MARK: - Private Properties
    
    private var trimmedTaskTitle: String {
        taskTitle.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private var isTaskTitleEmpty: Bool {
        trimmedTaskTitle == ""
    }
    
    private let tasksStorage: TasksStorage
    private var userDefaultsStorage: SettingsStorage &
                                     OnboardingStorage &
                                     LastUsedValuesStorage
    
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(
        tasksStorage: TasksStorage = DI.storages.taskStorage,
        userDefaultsStorage: SettingsStorage &
                             OnboardingStorage &
                             LastUsedValuesStorage = DI.storages.userDefaultsStorage,
        feedbackService: FeedbackService = DI.services.feedbackService
    ) {
        self.tasksStorage = tasksStorage
        self.userDefaultsStorage = userDefaultsStorage
        self.feedbackService = feedbackService
        
        self.shrinkSlidersStep = userDefaultsStorage.shrinkSlidersStep
        
        totalTasksCount = tasksStorage.tasks.value.count
        
        addSubscriptions()
    }
    
    // MARK: - Public Methods
    
    func createTask() {
        let task = PomodoroTask(
            id: UUID(),
            title: isTaskTitleEmpty ? nil : trimmedTaskTitle,
            date: taskDate,
            completedInterval: taskCompletedInterval)
        tasksStorage.createTask(task: task)
        resetFields()
        performImpact()
    }
    
    func deleteAllTasks() {
        tasksStorage.deleteAllTasks()
        performImpact()
    }
    
    func resetOnboarding() {
        userDefaultsStorage.onboadingShowed = false
        userDefaultsStorage.deleteFeatureUsed = false
        performImpact()
    }
    
    func resetLastUsedValues() {
        userDefaultsStorage.lastFocusTime = PomodoroState.focus.defaultWaitingTime
        userDefaultsStorage.lastBreakTime = PomodoroState.break.defaultWaitingTime
        userDefaultsStorage.lastLongBreakTime = PomodoroState.longBreak.defaultWaitingTime
        userDefaultsStorage.lastStagesCount = PomodoroState.defaultStagesCount
        performImpact()
    }
    
    func shouldChangeText(range: NSRange, replacementText: String) -> Bool {
        let currentText = taskTitle
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: replacementText)
        return isValidTitle(title: updatedText)
    }
    
    // MARK: - Private Methods
    
    private func addSubscriptions() {
        tasksStorage.tasks.sink { [weak self] tasks in
            self?.totalTasksCount = tasks.count
        }
        .store(in: &subscriptions)
    }
    
    private func resetFields() {
        taskTitle = ""
        taskDate = Date.now
        taskCompletedInterval = 0
    }
    
    private func isValidTitle(title: String) -> Bool {
        !title.contains(where: \.isNewline) && title.count <= Constants.maxTitleLength
    }
}
