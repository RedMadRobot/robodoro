//
//  AppReloadSavedData.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 19.01.2023.
//

import Foundation

// MARK: - AppReloadSavedData

struct AppReloadSavedData: Codable {
    let backgroundDate: Date?
    let taskId: UUID
    let leftTime: TimeInterval
    let focusTime: TimeInterval
    let breakTime: TimeInterval
    let longBreakTime: TimeInterval
    let pomodoroServiceSavedData: PomodoroServiceSavedData
}

// MARK: - PomodoroServiceSavedData

struct PomodoroServiceSavedData: Codable {
    let stagesCount: Int
    let innerIndex: Int
    let outerIndex: Int
}
