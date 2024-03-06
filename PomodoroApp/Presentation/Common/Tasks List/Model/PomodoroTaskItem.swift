//
//  PomodoroTaskItem.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 21.04.2023.
//

import Foundation

struct PomodoroTaskItem: Equatable {
    let id: UUID
    let title: String
    let date: String
    var completedInterval: String
    
    init(task: PomodoroTask) {
        self.id = task.id
        self.title = task.title ?? Strings.TasksList.unnamedTaskTitle
        self.date = DateFormatter.onlyDateFormatter.string(from: task.date)
        self.completedInterval = String(task.completedInterval.minutesIgnoringHours)
    }
}
