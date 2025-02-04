//
//  Date+Extension.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 23.12.2022.
//

import Foundation

extension Date {
    
    enum Weekday: Int {
        case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
    }
    
    func startOfWeek(calendar: Calendar, _ firstWeekday: Weekday = .monday) -> Date? {
        var cal = calendar
        cal.firstWeekday = firstWeekday.rawValue
        var dateComponents = cal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        dateComponents.setTimeComponentsToBeginning()
        return cal.date(from: dateComponents)
    }
    
    func endOfWeek(calendar: Calendar, _ firstWeekday: Weekday = .monday) -> Date? {
        guard let startOfWeek = startOfWeek(calendar: calendar, firstWeekday) else { return nil }
        var dateComponents = DateComponents()
        dateComponents.weekOfYear = 1
        dateComponents.day = -1
        dateComponents.setTimeComponentsToEnd()
        return Calendar.current.date(byAdding: dateComponents, to: startOfWeek)
    }
    
    func startOfPreviousWeek(calendar: Calendar, _ firstWeekday: Weekday = .monday) -> Date? {
        guard let startOfWeek = startOfWeek(calendar: calendar, firstWeekday) else { return nil }
        var dateComponents = DateComponents()
        dateComponents.weekOfYear = -1
        return Calendar.current.date(byAdding: dateComponents, to: startOfWeek)
    }
    
    func endOfPreviousWeek(calendar: Calendar, _ firstWeekday: Weekday = .monday) -> Date? {
        guard let startOfWeek = endOfWeek(calendar: calendar, firstWeekday) else { return nil }
        var dateComponents = DateComponents()
        dateComponents.weekOfYear = -1
        return Calendar.current.date(byAdding: dateComponents, to: startOfWeek)
    }
}

extension Calendar {
    
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int? {
        let fromDate = startOfDay(for: from)
        let toDate = startOfDay(for: to)
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate)
        
        guard let daysNotIncludingToday = numberOfDays.day else { return nil }
        return daysNotIncludingToday + 1
    }
}

fileprivate extension DateComponents {
    mutating func setTimeComponentsToBeginning() {
        self.hour = 0
        self.minute = 0
        self.second = 0
        self.nanosecond = 0
    }
    
    mutating func setTimeComponentsToEnd() {
        self.hour = 23
        self.minute = 59
        self.second = 59
        self.nanosecond = 59
    }
}
