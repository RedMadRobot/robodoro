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
        maxStagesCount: Int,
        activeStagesCount: Int,
        lastStageState: StageElementViewState
    )
    func update(
        pomodoroState: PomodoroState,
        timerState: TimerState,
        stageEndDate: Date,
        activeStagesCount: Int,
        lastStageState: StageElementViewState
    )
    func stop()
}

// MARK: - LiveActivityServiceImpl

final class LiveActivityServiceImpl: LiveActivityService {
    
    // MARK: - Private Properties
    
    private var activity: Activity<LiveActivityAttributes>? {
        Activity<LiveActivityAttributes>.activities.first
    }
    
    // MARK: - Public Methods
    
    func start(
        pomodoroState: PomodoroState,
        timerState: TimerState,
        stageEndDate: Date,
        maxStagesCount: Int,
        activeStagesCount: Int,
        lastStageState: StageElementViewState
    ) {
        // Попытаться обновить существующую активити
        if let _ = activity {
            return update(
                pomodoroState: pomodoroState,
                timerState: timerState,
                stageEndDate: stageEndDate,
                activeStagesCount: activeStagesCount,
                lastStageState: lastStageState)
        }
        
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        let attributes = LiveActivityAttributes(maxStagesCount: maxStagesCount)
        let state = LiveActivityAttributes.ContentState(
            pomodoroState: pomodoroState,
            timerState: timerState,
            stageEndDate: stageEndDate,
            activeStagesCount: activeStagesCount,
            lastStageState: lastStageState)

        _ = try? Activity<LiveActivityAttributes>.request(
            attributes: attributes,
            contentState: state,
            pushType: nil)
    }
    
    func update(
        pomodoroState: PomodoroState,
        timerState: TimerState,
        stageEndDate: Date,
        activeStagesCount: Int,
        lastStageState: StageElementViewState
    ) {
        guard let activity else { return }
        Task {
            let newState = LiveActivityAttributes.ContentState(
                pomodoroState: pomodoroState,
                timerState: timerState,
                stageEndDate: stageEndDate,
                activeStagesCount: activeStagesCount,
                lastStageState: lastStageState)
            await activity.update(using: newState)
        }
    }
    
    func stop() {
        guard let activity else { return }
        
        // Сомнительное решение, возможно нужно пересмотреть
        let semaphore = DispatchSemaphore(value: 0)
        Task {
            await activity.end(dismissalPolicy: .immediate)
            semaphore.signal()
        }
        semaphore.wait()
    }
}
