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
    func updateTime(ofTaskWithId id: UUID, newTime: TimeInterval)
    func deleteTask(withId id: UUID)
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
    
    func updateTime(ofTaskWithId id: UUID, newTime: TimeInterval) {
        let predicate = NSPredicate(format: "id = %@", id as CVarArg)
        let result = backgroundContext.fetchFirst(PomodoroTaskObject.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let taskObject = managedObject {
                taskObject.completedInterval = newTime
            }
        case .failure(_):
            print("Couldn't fetch PomodoroTaskObject to save")
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
            print("Couldn't fetch PomodoroTaskObject to save")
        }
        backgroundContext.saveIfNeeded()
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
