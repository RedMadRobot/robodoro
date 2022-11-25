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
        stageEndDate: Date,
        stagesCount: Int,
        filledCount: Int,
        isPomodoroFinished: Bool
    )
    func stop()
    func update(
        pomodoroState: PomodoroState,
        timerState: TimerState,
        stageEndDate: Date,
        filledCount: Int,
        isPomodoroFinished: Bool
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
        stageEndDate: Date,
        stagesCount: Int,
        filledCount: Int,
        isPomodoroFinished: Bool
    ) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        let attributes = LiveActivityAttributes(stagesCount: stagesCount)
        let state = LiveActivityAttributes.ContentState(
            pomodoroState: pomodoroState,
            timerState: timerState,
            stageEndDate: stageEndDate,
            filledCount: filledCount,
            isPomodoroFinished: isPomodoroFinished)

        activity = try? Activity<LiveActivityAttributes>.request(
            attributes: attributes,
            contentState: state,
            pushType: nil)
    }
    
    func stop() {
        guard let activity = activity else { return }
        
        // Сомнительное решение, возможно нужно пересмотреть
        let semaphore = DispatchSemaphore(value: 0)
        Task {
            await activity.end(dismissalPolicy: .immediate)
            self.activity = nil
            semaphore.signal()
        }
        semaphore.wait()
    }
    
    func update(
        pomodoroState: PomodoroState,
        timerState: TimerState,
        stageEndDate: Date,
        filledCount: Int,
        isPomodoroFinished: Bool
    ) {
        guard let activity = activity else { return }
        Task {
            let newState = LiveActivityAttributes.ContentState(
                pomodoroState: pomodoroState,
                timerState: timerState,
                stageEndDate: stageEndDate,
                filledCount: filledCount,
                isPomodoroFinished: isPomodoroFinished)
            await activity.update(using: newState)
        }
    }
}
