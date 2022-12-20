//
//  DateFormatter+Extension.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 20.12.2022.
//

import Foundation

extension DateFormatter {
    
    static var onlyDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }
}
