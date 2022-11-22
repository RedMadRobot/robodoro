//
//  TimerState.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 17.11.2022.
//

import UIKit

enum TimerState: Codable, Hashable {
    case initial
    case running
    case ended
    case paused(TimeInterval)
    
    var isPaused: Bool {
        switch self {
        case .running, .ended:
            return false
        case .paused, .initial:
            return true
        }
    }
}

// MARK: - Color

extension TimerState {
    
    var backgroundColor: UIColor {
        return Colors.pauseBackground
    }
    
    var strokeColor: UIColor {
        return Colors.pauseLine
    }
}
