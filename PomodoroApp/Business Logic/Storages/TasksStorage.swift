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
    func createTask(withTitle title: String?) -> PomodoroTask
    func updateTime(ofTaskWithId id: UUID, newTime: TimeInterval)
    func deleteTask(withId id: UUID)
}

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
        saveData(context: managedObjectContext)
        return task
    }
    
    func updateTime(ofTaskWithId id: UUID, newTime: TimeInterval) {
        let predicate = NSPredicate(format: "id = %@", id as CVarArg)
        let result = fetchFirst(PomodoroTaskObject.self, predicate: predicate, context: backgroundContext)
        switch result {
        case .success(let managedObject):
            if let taskObject = managedObject {
                taskObject.completedInterval = newTime
            }
        case .failure(_):
            print("Couldn't fetch PomodoroTaskObject to save")
        }
        saveData(context: backgroundContext)
    }
    
    func deleteTask(withId id: UUID) {
        let predicate = NSPredicate(format: "id = %@", id as CVarArg)
        let result = fetchFirst(PomodoroTaskObject.self, predicate: predicate, context: backgroundContext)
        switch result {
        case .success(let managedObject):
            if let taskObject = managedObject {
                backgroundContext.delete(taskObject)
            }
        case .failure(_):
            print("Couldn't fetch PomodoroTaskObject to save")
        }
        saveData(context: backgroundContext)
    }
    
    // MARK: - Private Methods
    
    private func saveData(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                NSLog("Unresolved error saving context: \(error), \(error.userInfo)")
            }
        }
    }
}

extension TasksStorageCoreDataImpl: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let tasksObjects = controller.fetchedObjects as? [PomodoroTaskObject] {
            self.tasks.value = tasksObjects.compactMap {
                PomodoroTask(coreDataObject: $0)
            }
        }
    }
    
    private func fetchFirst<T: NSManagedObject>(
        _ objectType: T.Type,
        predicate: NSPredicate?,
        context: NSManagedObjectContext
    ) -> Result<T?, Error> {
        let request = objectType.fetchRequest()
        request.predicate = predicate
        request.fetchLimit = 1
        do {
            let result = try context.fetch(request) as? [T]
            return .success(result?.first)
        } catch {
            return .failure(error)
        }
    }
}
