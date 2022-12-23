//
//  NumberFormatter+Extension.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 23.12.2022.
//

import Foundation

extension NumberFormatter {
    
    func getValue(double: Double) -> String {
        return self.string(from: double as NSNumber) ?? "NaN"
    }
    
    static var oneSignificantDigitFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        return formatter
    }
}
