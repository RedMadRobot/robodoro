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
}
