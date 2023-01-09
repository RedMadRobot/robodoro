//
//  TasksStorage.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 19.12.2022.
//

import Combine
import CoreData
import Foundation

protocol TasksStorage {
    var tasks: CurrentValueSubject<[PomodoroTask], Never> { get }
    func getAllTasks() -> [PomodoroTask]
    func createTask(withTitle title: String?) -> PomodoroTask
    func updateTime(ofTaskWithId id: UUID, newTime: TimeInterval)
    func deleteTask(withId id: UUID)
}

final class TasksStorageCoreDataImpl: NSObject, TasksStorage {
    
    // MARK: - Public Properties
    
    private(set) var tasks: CurrentValueSubject<[PomodoroTask], Never>
    
    // MARK: - Private Properties
    
    
    // MARK: - Init
    
    override init() {
        let calendar = Calendar.current
        
        let task0 = PomodoroTask(
            id: UUID(),
            title: "Задача в прошлое воскресенье",
            date: calendar.makeDate(year: 2023, month: 1, day: 8),
            completedInterval: 60 * 13)
        let task1 = PomodoroTask(
            id: UUID(),
            title: "Задача в понедельник этой недели",
            date: calendar.makeDate(year: 2023, month: 1, day: 9),
            completedInterval: 60 * 10 + 30)
        let task2 = PomodoroTask(
            id: UUID(),
            title: "Задача в среду этой недели",
            date: calendar.makeDate(year: 2023, month: 1, day: 11),
            completedInterval: 60 * 6 + 59)
        let task3 = PomodoroTask(
            id: UUID(),
            title: "Задача в пятницу этой недели1",
            date: calendar.makeDate(year: 2023, month: 1, day: 13),
            completedInterval: 60 * 10 + 30)
        let task4 = PomodoroTask(
            id: UUID(),
            title: "Задача в пятницу этой недели2",
            date: calendar.makeDate(year: 2023, month: 1, day: 13),
            completedInterval: 60 * 60 * 10)
        let longNameTask = PomodoroTask(
            id: UUID(),
            title: "Равным образом укрепление и развитие структуры спо",
            date: calendar.makeDate(year: 2023, month: 1, day: 13),
            completedInterval: 32)
        
        let tasks = [task0, task1, task2, task3, task4, longNameTask]
        
        self.tasks = CurrentValueSubject<[PomodoroTask], Never>(tasks)
        
        super.init()
    }
    
    // MARK: - Public Methods
    
    func getAllTasks() -> [PomodoroTask] {
        // TODO: - Implement
        return tasks.value
    }
    
    @discardableResult
    func createTask(withTitle title: String?) -> PomodoroTask {
        // TODO: - Implement
        let task = PomodoroTask(
            id: UUID(),
            title: title,
            date: Date.now,
            completedInterval: 0)
        print("Task created")
        return task
    }
    
    func updateTime(ofTaskWithId id: UUID, newTime: TimeInterval) {
        // TODO: - Implement
        print("Task updated")
    }
    
    func deleteTask(withId id: UUID) {
        // TODO: - Implement
        tasks.value.removeAll { $0.id == id }
        print("Task deleted")
    }
    
    // MARK: - Private Methods
}

extension TasksStorageCoreDataImpl: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
}
