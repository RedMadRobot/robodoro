//
//  DateComponentsFormatter+Extension.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 15.11.2022.
//

import Foundation

extension DateComponentsFormatter {
    
    func getFormattedTime(time: TimeInterval) -> String {
        self.string(from: time) ?? "NaN"
    }
    
    static var minutesAndSecondsFormatter: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }
}
