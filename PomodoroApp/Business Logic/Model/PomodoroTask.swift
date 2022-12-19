//
//  PomodoroTask.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 19.12.2022.
//

import Foundation

struct PomodoroTask {
    let id: UUID
    let title: String?
    let date: Date
    let completedInterval: TimeInterval
}
