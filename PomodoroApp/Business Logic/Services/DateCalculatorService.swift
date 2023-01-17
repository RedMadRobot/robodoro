//
//  DateCalculatorService.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 23.12.2022.
//

import Foundation

// MARK: - DateCalculatorService

protocol DateCalculatorService {
    var startOfWeek: Date? { get }
    func calculateCurrentWeekDailyAverageFocusValue(tasks: [PomodoroTask]) -> Double
    func calculatePreviousWeekDailyAverageFocusValue(tasks: [PomodoroTask]) -> Double
    func calculateCurrentWeekTotalFocusValue(tasks: [PomodoroTask]) -> Double
    func calculatePreviousWeekTotalFocusValue(tasks: [PomodoroTask]) -> Double
}

// MARK: - DateCalculatorServiceImpl

final class DateCalculatorServiceImpl: DateCalculatorService {
    
    // MARK: - Public Properties
    
    var startOfWeek: Date? {
        Date().startOfWeek(calendar: calendar)
    }
    
    // MARK: - Private Properties
    
    private let calendar = Calendar.current
    
    // MARK: - Public Methods
    
    func calculateCurrentWeekDailyAverageFocusValue(tasks: [PomodoroTask]) -> Double {
        guard let startOfWeek = Date().startOfWeek(calendar: calendar),
              let daysOfWeekPassed = calendar.numberOfDaysBetween(startOfWeek, and: Date()) else { return 0 }
        let focusedTime = currentWeekTasks(allTasks: tasks).reduce(0, { $0 + $1.completedInterval }).minutesIgnoringHours
        return Double(focusedTime) / Double(daysOfWeekPassed)
    }
    
    func calculatePreviousWeekDailyAverageFocusValue(tasks: [PomodoroTask]) -> Double {
        let focusedTime = previousWeekTasks(allTasks: tasks).reduce(0, { $0 + $1.completedInterval }).minutesIgnoringHours
        return Double(focusedTime) / Double(7)
    }
    
    func calculateCurrentWeekTotalFocusValue(tasks: [PomodoroTask]) -> Double {
        return Double(currentWeekTasks(allTasks: tasks).reduce(0, { $0 + $1.completedInterval }).minutesIgnoringHours)
    }
    
    func calculatePreviousWeekTotalFocusValue(tasks: [PomodoroTask]) -> Double {
        return Double(previousWeekTasks(allTasks: tasks).reduce(0, { $0 + $1.completedInterval }).minutesIgnoringHours)
    }
    
    // MARK: - Private Methods
    
    private func currentWeekTasks(allTasks: [PomodoroTask]) -> [PomodoroTask] {
        guard let startOfWeek = Date().startOfWeek(calendar: calendar),
              let endOfWeek = Date().endOfWeek(calendar: calendar) else { return [] }
        
        let filteredTasks = allTasks.filter { task in
            task.date >= startOfWeek && task.date <= endOfWeek
        }
        
        return filteredTasks
    }
    
    private func previousWeekTasks(allTasks: [PomodoroTask]) -> [PomodoroTask] {
        guard let startOfWeek = Date().startOfPreviousWeek(calendar: calendar),
              let endOfWeek = Date().endOfPreviousWeek(calendar: calendar) else { return [] }
        
        let filteredTasks = allTasks.filter { task in
            task.date >= startOfWeek && task.date <= endOfWeek
        }
        
        return filteredTasks
    }
}
