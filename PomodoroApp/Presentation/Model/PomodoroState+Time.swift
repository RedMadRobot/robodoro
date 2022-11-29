//
//  PomodoroState.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 11.11.2022.
//

import UIKit

extension PomodoroState {
    
    // TODO: - Вернуть нормальное время
    var waitingTime: TimeInterval {
        switch self {
        case .focus, .longBreak:
//            return 60.0 * 25
            return 10
        case .break:
//            return 60.0 * 6
            return 10
        }
    }
}
