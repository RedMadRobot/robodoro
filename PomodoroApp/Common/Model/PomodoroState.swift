//
//  PomodoroState.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 17.11.2022.
//

import SwiftUI

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
            return Strings.PomodoroState.Title.focus.uppercased()
        case .break:
            return Strings.PomodoroState.Title.break.uppercased()
        case .longBreak:
            return Strings.PomodoroState.Title.longBreak.uppercased()
        }
    }
    
    var miniTitle: String {
        switch self {
        case .focus:
            return Strings.PomodoroState.Title.focus.capitalized
        case .break:
            return Strings.PomodoroState.Title.break.capitalized
        case .longBreak:
            return Strings.PomodoroState.Title.longBreak.capitalized
        }
    }
}

// MARK: - Color

extension PomodoroState {
    
    var backgroundColor: Color {
        switch self {
        case .focus:
            return Colors.focusRed.swiftUIColor
        case .break:
            return Colors.breakPurple.swiftUIColor
        case .longBreak:
            return Colors.longBreakGreen.swiftUIColor
        }
    }
    
    var strokeColor: Color {
        switch self {
        case .focus:
            return Colors.focusLine.swiftUIColor
        case .break:
            return Colors.breakLine.swiftUIColor
        case .longBreak:
            return Colors.longBreakLine.swiftUIColor
        }
    }
    
    var islandImage: Image {
        switch self {
        case .focus:
            return Images.islandFocus.swiftUIImage
        case .break:
            return Images.islandBreak.swiftUIImage
        case .longBreak:
            return Images.islandLongBreak.swiftUIImage
        }
    }
}
