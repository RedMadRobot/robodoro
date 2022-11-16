//
//  LiveActivityAttributes.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 16.11.2022.
//

import ActivityKit
import Foundation

struct LiveActivityAttributes: ActivityAttributes {
    
    public struct ContentState: Codable, Hashable {
        var pomodoroState: PomodoroState
        var timerState: TimerState
        var leftTime: String
        var filledCount: Int
    }
    
    var stagesCount: Int
}
