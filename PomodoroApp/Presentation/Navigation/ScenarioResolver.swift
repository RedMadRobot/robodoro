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
        guard let _ = userDefaultsStorage.appReloadSavedData else { return false }
        return true
    }
    
    var readyToResumeTask: Bool {
        guard let id = timedPomodoroWorker.currentTaskId,
              let _ = tasksStorage.getTask(withId: id) else {
            timedPomodoroWorker.reset()
            return false
        }
        return true
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
    
    func setupPomodoroFromSavedData() {
        guard let data = userDefaultsStorage.appReloadSavedData else { return }
        timedPomodoroWorker.setup(savedData: data)
    }
}
