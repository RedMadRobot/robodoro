//
//  PomodoroState.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 17.11.2022.
//

import UIKit

enum PomodoroState: Codable, Hashable {
    case focus
    case `break`
    case longBreak
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
