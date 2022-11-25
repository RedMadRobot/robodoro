//
//  ImageHelper.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 25.11.2022.
//

import UIKit

final class ImageHelper {
    
    static func getMainButtonImage(
        timerState: TimerState,
        isPomodoroFihished: Bool
    ) -> UIImage {
        switch (timerState, isPomodoroFihished) {
        case (.running, _):
            return Images.pause
        case (.ended, true):
            return Images.stop
        case (.initial, _), (.paused, _), (.ended, false):
            return Images.play
        }
    }
}
