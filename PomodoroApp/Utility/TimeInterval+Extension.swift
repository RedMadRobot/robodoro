//
//  TimeInterval+Extension.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 18.11.2022.
//

import Foundation

extension TimeInterval {
    
    var minutes: Int {
        (Int(self) / 60) % 60
    }
    
    // Включает значения больше 60:00
    var minutesIgnoringHours: Int {
        Int(self) / 60
    }
    
    var seconds: Int {
        Int(self) % 60
    }
}
