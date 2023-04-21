//
//  DateFormatter+Extension.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 20.12.2022.
//

import Foundation

extension DateFormatter {
    
    static let onlyDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
}
