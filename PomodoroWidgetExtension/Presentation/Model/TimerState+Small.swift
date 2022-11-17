//
//  TimerState+Small.swift
//  PomodoroWidgetExtensionExtension
//
//  Created by Петр Тартынских  on 17.11.2022.
//

import UIKit

// MARK: - Image

extension TimerState {
    
    var smallButtonImage: UIImage {
        switch self {
        case .running:
            return Images.smallPause
        case .ended:
            return Images.smallStop
        case .initial, .paused:
            return Images.smallPlay
        }
    }
}
