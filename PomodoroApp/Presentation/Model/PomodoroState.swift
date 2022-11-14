//
//  PomodoroState.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 11.11.2022.
//

import UIKit

enum PomodoroState {
    case focus
    case `break`
    case longBreak
}

// MARK: - Colors

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
