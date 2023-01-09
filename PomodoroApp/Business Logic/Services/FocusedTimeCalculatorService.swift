//
//  FocusedTimeCalculatorService.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 23.12.2022.
//

import Foundation

// MARK: - FocusedTimeCalculatorService

protocol FocusedTimeCalculatorService {
    func calculateWeekDailyAverageFocusValue(tasks: [PomodoroTask]) -> Double
    func calculateWeekTotalFocusValue(tasks: [PomodoroTask]) -> Double
}

// MARK: - FocusedTimeCalculatorServiceImpl

final class FocusedTimeCalculatorServiceImpl: FocusedTimeCalculatorService {
    
    // MARK: - Private Properties
    
    private let calendar = Calendar.current
    
    // MARK: - Public Methods
    
    func calculateWeekDailyAverageFocusValue(tasks: [PomodoroTask]) -> Double {
        guard let startOfWeek = Date().startOfWeek(calendar: calendar),
              let daysOfWeekPassed = calendar.numberOfDaysBetween(startOfWeek, and: Date()) else { return 0 }
        let focusedTime = currentWeekTasks(tasks: tasks).reduce(0, { $0 + $1.completedInterval }).minutesIgnoringHours
        return Double(focusedTime) / Double(daysOfWeekPassed)
    }
    
    func calculateWeekTotalFocusValue(tasks: [PomodoroTask]) -> Double {
       return Double(currentWeekTasks(tasks: tasks).reduce(0, { $0 + $1.completedInterval }).minutesIgnoringHours)
    }
    
    // MARK: - Private Methods
    
    private func currentWeekTasks(tasks: [PomodoroTask]) -> [PomodoroTask] {
        guard let startOfWeek = Date().startOfWeek(calendar: calendar),
              let endOfWeek = Date().endOfWeek(calendar: calendar) else { return [] }
        return tasks.filter { task in
            task.date >= startOfWeek && task.date <= endOfWeek
        }
    }
}
