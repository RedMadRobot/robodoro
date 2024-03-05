//
//  LiveActivityAttributes.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 16.11.2022.
//

import ActivityKit
import SwiftUI

struct LiveActivityAttributes: ActivityAttributes {
    
    public struct ContentState: Codable, Hashable {
        var pomodoroState: PomodoroState
        var timerState: TimerState
        var stageEndDate: Date
        var activeStagesCount: Int
        var lastStageState: StageElementViewState
        
        var backgroundColor: Color {
            ColorHelper.getBackgroundColor(
                pomodoroState: pomodoroState,
                timerState: timerState
            )
        }
        
        var strokeColor: Color {
            ColorHelper.getStrokeColor(
                pomodoroState: pomodoroState,
                timerState: timerState
            )
        }
        
        var islandImage: Image {
            switch timerState {
            case .initial, .paused:
                return Images.islandPause.swiftUIImage
            case .running, .ended:
                return pomodoroState.islandImage
            }
        }
        
        var buttonImage: Image {
            timerState.smallButtonImage
        }
        
        var actionLink: String {
            timerState.actionLink
        }
    }
    
    var maxStagesCount: Int
}
