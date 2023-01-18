//
//  ScenarioResolver.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 18.01.2023.
//

import Foundation

final class ScenarioResolver {
    
    // MARK: - Public Properties
    
    var shouldShowPreviousResults: Bool {
        guard let startOfWeek = dateCalculatorService.startOfWeek else { return false }
        let oldTasks = tasksStorage.getTasks(before: startOfWeek)
        return !oldTasks.isEmpty
    }
    
    var shouldShowOnboarding: Bool {
        !userDefaultsStorage.onboadingShowed
    }
    
    var shouldShowPomodoro: Bool {
        // TODO: - Показать экран с таймером, если есть сохраненное состояние
        false
    }
    
    // MARK: - Private Properties
    
    private let dateCalculatorService: DateCalculatorService
    private let tasksStorage: TasksStorage
    private var userDefaultsStorage: OnboardingStorage
    private let timedPomodoroWorker: TimedPomodoroWorker
    
    // MARK: - Init
    
    init(
        dateCalculatorService: DateCalculatorService = DI.services.dateCalculatorService,
        tasksStorage: TasksStorage = DI.storages.taskStorage,
        userDefaultsStorage: OnboardingStorage = DI.storages.userDefaultsStorage,
        timedPomodoroWorker: TimedPomodoroWorker = DI.workers.timedPomodoroWorker
    ) {
        self.dateCalculatorService = dateCalculatorService
        self.tasksStorage = tasksStorage
        self.userDefaultsStorage = userDefaultsStorage
        self.timedPomodoroWorker = timedPomodoroWorker
    }
    
    // MARK: - Public Methods
    
    func onboardingCompleted() {
        userDefaultsStorage.onboadingShowed = true
    }
}
