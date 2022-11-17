//
//  TimerState.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 14.11.2022.
//

import UIKit

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
