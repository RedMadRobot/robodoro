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
    
    private let timedPomodoroWorker: TimedPomodoroWorker
    
    private let focusedTimeCalculatorService: FocusedTimeCalculatorService
    
    // MARK: - Init
    
    init(
        timedPomodoroWorker: TimedPomodoroWorker = DI.workers.timedPomodoroWorker,
        focusedTimeCalculatorService: FocusedTimeCalculatorService = DI.services.focusedTimeCalculatorService,
        feedbackService: FeedbackService = DI.services.feedbackService
    ) {
        self.timedPomodoroWorker = timedPomodoroWorker
        self.focusedTimeCalculatorService = focusedTimeCalculatorService
        self.feedbackService = feedbackService
        
//        let tasks = Array(1...10).map {
//            PomodoroTask(
//                id: UUID(),
//                title: "Task № \($0)",
//                date: Date(),
//                completedInterval: 60 * 5)
//        }
        
        let calendar = Calendar.current
        
        let task0 = PomodoroTask(
            id: UUID(),
            title: "Задача в прошлое воскресенье",
            date: calendar.makeDate(year: 2022, month: 12, day: 18),
            completedInterval: 60 * 13)
        let task1 = PomodoroTask(
            id: UUID(),
            title: "Задача в понедельник этой недели",
            date: calendar.makeDate(year: 2022, month: 12, day: 19),
            completedInterval: 60 * 10 + 30)
        let task2 = PomodoroTask(
            id: UUID(),
            title: "Задача в среду этой недели",
            date: calendar.makeDate(year: 2022, month: 12, day: 21),
            completedInterval: 60 * 6 + 59)
        let task3 = PomodoroTask(
            id: UUID(),
            title: "Задача в пятницу этой недели1",
            date: calendar.makeDate(year: 2022, month: 12, day: 23),
            completedInterval: 60 * 10 + 30)
        let task4 = PomodoroTask(
            id: UUID(),
            title: "Задача в пятницу этой недели2",
            date: calendar.makeDate(year: 2022, month: 12, day: 23),
            completedInterval: 60 * 60 * 10)
        let longNameTask = PomodoroTask(
            id: UUID(),
            title: "Равным образом укрепление и развитие структуры спо",
            date: calendar.makeDate(year: 2022, month: 12, day: 23),
            completedInterval: 32)
        
        let tasks = [task0, task1, task2, task3, task4, longNameTask]
        
        self.tasks = tasks
        self.dailyAverageFocusValue = focusedTimeCalculatorService.calculateWeekDailyAverageFocusValue(tasks: tasks)
        self.totalFocusValue = focusedTimeCalculatorService.calculateWeekTotalFocusValue(tasks: tasks)
    }
    
    // MARK: - Public Methods
    
    func prepareToDeleteTask(task: PomodoroTask) {
        taskToDelete = task
    }
    
    func deleteSelectedTask() {
        tasks.removeAll { $0 == taskToDelete }
        taskToDelete = nil
    }
    
    // MARK: - Private Methods
    
    private func recalculateTime() {
        dailyAverageFocusValue = focusedTimeCalculatorService.calculateWeekDailyAverageFocusValue(tasks: tasks)
        totalFocusValue = focusedTimeCalculatorService.calculateWeekTotalFocusValue(tasks: tasks)
    }
}
