//
//  PreviousResultsViewModel.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 17.01.2023.
//

import Nivelir
import SwiftUI

final class PreviousResultsViewModel: ViewModel {
    
    // MARK: - Private Properties
    
    private let navigator: ScreenNavigator
    private let screens: Screens
    
    private let dateCalculatorService: DateCalculatorService
    private let tasksStorage: TasksStorage
    
    // MARK: - Public Properties
        
    private(set) var taskItems: [PomodoroTaskItem]
    private(set) var dailyAverageFocusValue: Double
    private(set) var totalFocusValue: Double
    private(set) var feedbackService: FeedbackService
    
    weak var viewController: UIViewController?
    
    // MARK: - Init
    
    init(
        navigator: ScreenNavigator,
        screens: Screens,
        dateCalculatorService: DateCalculatorService = DI.services.dateCalculatorService,
        tasksStorage: TasksStorage = DI.storages.taskStorage,
        feedbackService: FeedbackService = DI.services.feedbackService
    ) {
        self.navigator = navigator
        self.screens = screens
        self.dateCalculatorService = dateCalculatorService
        self.tasksStorage = tasksStorage
        self.feedbackService = feedbackService
        
        guard let startOfWeek = dateCalculatorService.startOfWeek else {
            self.taskItems = []
            self.dailyAverageFocusValue = 0
            self.totalFocusValue = 0
            return
        }
        
        let previousTasks = tasksStorage.getTasks(before: startOfWeek)
        
        self.taskItems = previousTasks.map { PomodoroTaskItem(task: $0) }
        self.dailyAverageFocusValue = dateCalculatorService.calculatePreviousWeekDailyAverageFocusValue(tasks: previousTasks)
        self.totalFocusValue = dateCalculatorService.calculatePreviousWeekTotalFocusValue(tasks: previousTasks)
    }
    
    // MARK: - Public Methods
    
    func viewDidAppear() {
        viewController?.bottomSheet?.shouldDismiss = { false }
    }
    
    func confirmButtonTapped() {
        guard let startOfWeek = dateCalculatorService.startOfWeek else { return }
        tasksStorage.deleteTasks(before: startOfWeek)
        
        navigator.navigate { route in
            route
                .top(.container)
                .presenting
                .dismiss()
        }
    }
}
