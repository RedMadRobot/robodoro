//
//  TasksStorage.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 19.12.2022.
//

import Foundation

protocol TasksStorage {
    func createTask(withName: String?)
    func updateTime(ofTaskWithId: UUID, newTime: TimeInterval)
    func deleteTask(withId: Int)
}

//final class TasksStorageImpl {
//
//}
