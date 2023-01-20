//
//  Text+Timer.swift
//  PomodoroWidgetExtensionExtension
//
//  Created by Anna Kocheshkova on 17.01.2023.
//

import SwiftUI

extension Text {
    init(state: LiveActivityAttributes.ContentState) {
        let dateComponentsFormatter: DateComponentsFormatter = .minutesAndSecondsFormatter
        switch state.timerState {
        case .ended:
            self.init(dateComponentsFormatter.getFormattedTime(time: 0))
        case .initial(let pausedTime), .paused(let pausedTime):
            self.init(dateComponentsFormatter.getFormattedTime(time: pausedTime))
        case .running:
            self.init(timerInterval: Date.now...state.stageEndDate)
        }
    }
}
