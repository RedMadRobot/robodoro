//
//  TimerState.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 14.11.2022.
//

import UIKit

enum TimerState {
    case running
    case ended
    case paused
}

// MARK: - Colors

extension TimerState {
    
    var isPaused: Bool {
        switch self {
        case .running, .ended:
            return false
        case .paused:
            return true
        }
    }
    
    var backgroundColor: UIColor {
        return Colors.pauseBackground
    }
    
    var strokeColor: UIColor {
        return Colors.pauseLine
    }
}
