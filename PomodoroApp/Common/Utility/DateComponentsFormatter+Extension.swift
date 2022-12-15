//
//  DateComponentsFormatter+Extension.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 15.11.2022.
//

import Foundation

extension DateComponentsFormatter {
    
    func getFormattedTime(time: TimeInterval) -> String {
        let string = self.string(from: time) ?? "NaN"
        return string.hasPrefix("0") && string.count > 4 ?
            .init(string.dropFirst()) : string
    }
    
    static var minutesAndSecondsFormatter: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }
}
