//
//  LiveActivityService.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 16.11.2022.
//

import ActivityKit
import Foundation

// MARK: - LiveActivityService

protocol LiveActivityService {
    func start(
        pomodoroState: PomodoroState,
        timerState: TimerState,
        leftTime: String,
        stagesCount: Int,
        filledCount: Int
    )
    func stop()
    func update(
        pomodoroState: PomodoroState,
        timerState: TimerState,
        leftTime: String,
        filledCount: Int
    )
}

// MARK: - LiveActivityServiceImpl

final class LiveActivityServiceImpl: LiveActivityService {
    
    // MARK: - Private Properties
    
    private var activity: Activity<LiveActivityAttributes>?
    
    // MARK: - Public Methods
    
    func start(
        pomodoroState: PomodoroState,
        timerState: TimerState,
        leftTime: String,
        stagesCount: Int,
        filledCount: Int
    ) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        let attributes = LiveActivityAttributes(stagesCount: stagesCount)
        let state = LiveActivityAttributes.ContentState(
            pomodoroState: pomodoroState,
            timerState: timerState,
            leftTime: leftTime,
            filledCount: filledCount)

        activity = try? Activity<LiveActivityAttributes>.request(
            attributes: attributes,
            contentState: state,
            pushType: nil)
    }
    
    func stop() {
        guard let activity = activity else { return }
        Task {
            await activity.end(dismissalPolicy: .immediate)
            self.activity = nil
        }
    }
    
    func update(
        pomodoroState: PomodoroState,
        timerState: TimerState,
        leftTime: String,
        filledCount: Int
    ) {
        guard let activity = activity else { return }
        Task {
            let newState = LiveActivityAttributes.ContentState(
                pomodoroState: pomodoroState,
                timerState: timerState,
                leftTime: leftTime,
                filledCount: filledCount)
            await activity.update(using: newState)
        }
    }
}
