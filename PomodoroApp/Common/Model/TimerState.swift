//
//  TimerState.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 17.11.2022.
//

import SwiftUI

enum TimerState: Codable, Hashable {
    case initial(TimeInterval)
    case running
    case ended
    case paused(TimeInterval)
}

// MARK: - Image

extension TimerState {
    
    var buttonImage: Image {
        switch self {
        case .running:
            return Images.pause.swiftUIImage
        case .ended:
            return Images.stop.swiftUIImage
        case .initial, .paused:
            return Images.play.swiftUIImage
        }
    }
}

// MARK: - Link

extension TimerState {
    
    var actionLink: String {
        switch self {
        case .running:
            return "pause"
        case .ended:
            return "stop"
        case .initial, .paused:
            return "start"
        }
    }
}
