//
//  PomodoroState.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 11.11.2022.
//

import UIKit

extension PomodoroState {
    
    var defaultWaitingTime: TimeInterval {
        switch self {
        case .focus, .longBreak:
            return 60.0 * 25
        case .break:
            return 60.0 * 6
        }
    }
}
