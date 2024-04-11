//
//  ScenarioResolver.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 18.01.2023.
//

import Foundation

// TODO: - [2.0.0] В процессе перехода на новую систему навигации, в будущем будет переработано

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
        timedPomodoroWorker.settedUp
    }
    
    // MARK: - Private Properties
    
    private let dateCalculatorService: DateCalculatorService
    private let tasksStorage: TasksStorage
    private var userDefaultsStorage: UserDefaultsStorage
    private let timedPomodoroWorker: TimedPomodoroWorker
    
    // MARK: - Init
    
    init(
        dateCalculatorService: DateCalculatorService = DI.services.dateCalculatorService,
        tasksStorage: TasksStorage = DI.storages.taskStorage,
        userDefaultsStorage: UserDefaultsStorage = DI.storages.userDefaultsStorage,
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
