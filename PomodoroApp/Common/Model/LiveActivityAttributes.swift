//
//  LiveActivityAttributes.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 16.11.2022.
//

import ActivityKit
import UIKit

struct LiveActivityAttributes: ActivityAttributes {
    
    public struct ContentState: Codable, Hashable {
        var pomodoroState: PomodoroState
        var timerState: TimerState
        var stageEndDate: Date
        var filledCount: Int
        var isPomodoroFinished: Bool
        
        var backgroundColor: UIColor {
            ColorHelper.getBackgroundColor(
                pomodoroState: pomodoroState,
                timerState: timerState,
                isPomodoroFihished: isPomodoroFinished)
        }
        
        var strokeColor: UIColor {
            ColorHelper.getStrokeColor(
                pomodoroState: pomodoroState,
                timerState: timerState,
                isPomodoroFihished: isPomodoroFinished)
        }
        
        var buttonImage: UIImage {
            ImageHelper.getMainButtonImage(
                timerState: timerState,
                isPomodoroFihished: isPomodoroFinished)
        }
    }
    
    var stagesCount: Int
}
