//
//  DateFormatter+Extension.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 15.11.2022.
//

import Foundation

extension DateFormatter {
    
    // MARK: - Constants
    
    private enum Constants {
        static let locale = Locale(identifier: "en_US_POSIX")
    }
    
    // MARK: - Public Properties
    
    public static var currentHourAndMinutesFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Constants.locale
        formatter.timeZone = .current
        formatter.dateFormat = "HH:mm"
        return formatter
    }
}
