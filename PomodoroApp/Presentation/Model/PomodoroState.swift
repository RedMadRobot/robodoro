//
//  PomodoroState.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 11.11.2022.
//

import UIKit

enum PomodoroState: Codable, Hashable {
    case focus
    case `break`
    case longBreak
}

// MARK: - Color

extension PomodoroState {
    
    var backgroundColor: UIColor {
        switch self {
        case .focus:
            return Colors.focusBackground
        case .break:
            return Colors.breakBackground
        case .longBreak:
            return Colors.longBreakBackground
        }
    }
    
    var strokeColor: UIColor {
        switch self {
        case .focus:
            return Colors.focusLine
        case .break:
            return Colors.breakLine
        case .longBreak:
            return Colors.longBreakLine
        }
    }
}

// MARK: - Title

extension PomodoroState {
    
    var title: String {
        switch self {
        case .focus:
            return "FOCUS"
        case .break:
            return "BREAK"
        case .longBreak:
            return "LONG BREAK"
        }
    }
}

// MARK: - TimeInterval

extension PomodoroState {
    
    var waitingTime: TimeInterval {
        switch self {
        case .focus, .longBreak:
            return 60.0 * 25
        case .break:
            return 60.0 * 6
        }
    }
}

