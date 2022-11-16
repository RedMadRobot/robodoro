//
//  TimerState.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 14.11.2022.
//

import UIKit

enum TimerState: Codable, Hashable {
    case initial
    case running
    case ended
    case paused
}

// MARK: - Color

extension TimerState {
    
    var isPaused: Bool {
        switch self {
        case .running, .ended:
            return false
        case .paused, .initial:
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

// MARK: - Image

extension TimerState {
    
    var buttonImage: UIImage {
        switch self {
        case .running:
            return Images.pause
        case .ended:
            return Images.stop
        case .initial, .paused:
            return Images.play
        }
    }
}
