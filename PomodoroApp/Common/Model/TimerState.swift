//
//  TimerState.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 17.11.2022.
//

import UIKit

enum TimerState: Codable, Hashable {
    case initial(TimeInterval)
    case running
    case ended
    case paused(TimeInterval)
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

// MARK: - Link

extension TimerState {
    
    var actionLink: String {
        switch self {
        case .running:
            return "pause"
        case .ended:
            return "stop"
        case .initial, .paused:
            return "start"
        }
    }
}
