//
//  TasksStorage.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 19.12.2022.
//

import Combine
import CoreData
import Foundation

// MARK: - TasksStorage

protocol TasksStorage {
    var tasks: CurrentValueSubject<[PomodoroTask], Never> { get }
    func createTask(withTitle title: String?) -> PomodoroTask
    func getTask(withId id: UUID) -> PomodoroTask?
    func updateTime(ofTaskWithId id: UUID, newTime: TimeInterval)
    func deleteTask(withId id: UUID)
    func deleteTasks(before date: Date)
    func getTasks(before date: Date) -> [PomodoroTask]
}

// MARK: - TasksStorageCoreDataImpl

final class TasksStorageCoreDataImpl: NSObject, TasksStorage {
    
    // MARK: - Public Properties
    
    private(set) var tasks: CurrentValueSubject<[PomodoroTask], Never> = .init([])
    
    // MARK: - Private Properties
    
    private var managedObjectContext: NSManagedObjectContext
    private var backgroundContext: NSManagedObjectContext
    
    private var fetchedResultsController: NSFetchedResultsController<PomodoroTaskObject>
    
    // MARK: - Init
    
    override init() {
        let persistentStore = PersistentStore()
        self.managedObjectContext = persistentStore.context
        self.backgroundContext = persistentStore.backgroundContext
        
        // TODO: - MOCK DATA, REMOVE
//        let calendar = Calendar.current
//
//        let task0 = PomodoroTaskObject(context: backgroundContext)
//        task0.id = UUID(uuidString: "B0C4EBEC-6D57-43E9-A964-F666E8A6B9CD")!
//        task0.title = "123"
//        task0.date = calendar.makeDate(year: 2023, month: 1, day: 2)
//        task0.completedInterval = 60 * 10
//
//        let task1 = PomodoroTaskObject(context: backgroundContext)
//        task1.id = UUID()
//        task1.date = calendar.makeDate(year: 2023, month: 1, day: 8)
//        task1.completedInterval = 60 * 5
//
//        let task2 = PomodoroTaskObject(context: backgroundContext)
//        task2.id = UUID()
//        task2.date = calendar.makeDate(year: 2023, month: 1, day: 9)
//        task2.completedInterval = 60 * 5
//
//        let task3 = PomodoroTaskObject(context: backgroundContext)
//        task3.id = UUID()
//        task3.date = calendar.makeDate(year: 2023, month: 1, day: 15)
//        task3.completedInterval = 60 * 5
//
//        try? backgroundContext.save()
        
        let request: NSFetchRequest<PomodoroTaskObject> = PomodoroTaskObject.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \PomodoroTaskObject.date, ascending: false)]
        self.fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        super.init()
        
        self.fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        
        if let tasksObjects = fetchedResultsController.fetchedObjects {
            self.tasks.value = tasksObjects.compactMap {
                PomodoroTask(coreDataObject: $0)
            }
        }
    }
    
    // MARK: - Public Methods
    
    @discardableResult
    func createTask(withTitle title: String?) -> PomodoroTask {
        let task = PomodoroTask(
            id: UUID(),
            title: title,
            date: Date.now,
            completedInterval: 0)
        
        let taskObject = PomodoroTaskObject(context: managedObjectContext)
        taskObject.id = task.id
        taskObject.title = task.title
        taskObject.date = task.date
        taskObject.completedInterval = task.completedInterval
        managedObjectContext.saveIfNeeded()
        return task
    }
    
    func getTask(withId id: UUID) -> PomodoroTask? {
        let predicate = NSPredicate(format: "id = %@", id as CVarArg)
        let result = managedObjectContext.fetchFirst(PomodoroTaskObject.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            guard let taskObject = managedObject else { return nil }
            return PomodoroTask(coreDataObject: taskObject)
        case .failure(_):
            print("Couldn't fetch PomodoroTaskObject")
            return nil
        }
    }
    
    func updateTime(ofTaskWithId id: UUID, newTime: TimeInterval) {
        let predicate = NSPredicate(format: "id = %@", id as CVarArg)
        let result = backgroundContext.fetchFirst(PomodoroTaskObject.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let taskObject = managedObject {
                taskObject.completedInterval = newTime
            }
        case .failure(_):
            print("Couldn't fetch PomodoroTaskObject")
        }
        backgroundContext.saveIfNeeded()
    }
    
    func deleteTask(withId id: UUID) {
        let predicate = NSPredicate(format: "id = %@", id as CVarArg)
        let result = backgroundContext.fetchFirst(PomodoroTaskObject.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let taskObject = managedObject {
                backgroundContext.delete(taskObject)
            }
        case .failure(_):
            print("Couldn't fetch PomodoroTaskObject")
        }
        backgroundContext.saveIfNeeded()
    }
    
    func deleteTasks(before date: Date) {
        let predicate = NSPredicate(format: "date < %@", date as NSDate)
        let result = backgroundContext.fetchAll(PomodoroTaskObject.self, predicate: predicate)
        switch result {
        case .success(let managedObjects):
            for managedObject in managedObjects {
                backgroundContext.delete(managedObject)
            }
        case .failure(_):
            print("Couldn't fetch PomodoroTaskObject")
        }
        backgroundContext.saveIfNeeded()
    }
    
    func getTasks(before date: Date) -> [PomodoroTask] {
        let predicate = NSPredicate(format: "date < %@", date as NSDate)
        let result = backgroundContext.fetchAll(PomodoroTaskObject.self, predicate: predicate)
        switch result {
        case .success(let managedObjects):
            return managedObjects.compactMap {
                PomodoroTask(coreDataObject: $0)
            }
        case .failure(_):
            print("Couldn't fetch PomodoroTaskObject")
            return []
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TasksStorageCoreDataImpl: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let tasksObjects = controller.fetchedObjects as? [PomodoroTaskObject] {
            self.tasks.value = tasksObjects.compactMap {
                PomodoroTask(coreDataObject: $0)
            }
        }
    }
}
