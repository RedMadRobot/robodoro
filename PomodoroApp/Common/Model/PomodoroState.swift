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
    
    var miniTitle: String {
        switch self {
        case .focus:
            return "Focus"
        case .break:
            return "Break"
        case .longBreak:
            return "Long Break"
        }
    }
}

// MARK: - Color

extension PomodoroState {
    
    var backgroundColor: UIColor {
        switch self {
        case .focus:
            return Colors.focusRed
        case .break:
            return Colors.breakPurple
        case .longBreak:
            return Colors.longBreakGreen
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
    
    var islandImage: UIImage {
        switch self {
        case .focus:
            return Images.islandFocus
        case .break:
            return Images.islandBreak
        case .longBreak:
            return Images.islandLongBreak
        }
    }
}
