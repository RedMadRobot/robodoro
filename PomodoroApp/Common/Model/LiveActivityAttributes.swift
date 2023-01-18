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
        var activeStagesCount: Int
        var lastStageState: StageElementViewState
        
        var backgroundColor: UIColor {
            ColorHelper.getBackgroundColor(
                pomodoroState: pomodoroState,
                timerState: timerState)
        }
        
        var strokeColor: UIColor {
            ColorHelper.getStrokeColor(
                pomodoroState: pomodoroState,
                timerState: timerState)
        }
        
        var islandImage: UIImage {
            switch timerState {
            case .initial, .paused:
                return Images.islandPause
            case .running, .ended:
                return pomodoroState.islandImage
            }
        }
        
        var buttonImage: UIImage {
            timerState.buttonImage
        }
        
        var actionLink: String {
            timerState.actionLink
        }
    }
    
    var maxStagesCount: Int
}
