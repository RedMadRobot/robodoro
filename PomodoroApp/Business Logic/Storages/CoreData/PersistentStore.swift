//
//  PersistentStore.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 10.01.2023.
//

import CoreData

struct PersistentStore {

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "PomodoroModel")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    var context: NSManagedObjectContext { container.viewContext }
    var backgroundContext: NSManagedObjectContext { container.newBackgroundContext() }
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                NSLog("Unresolved error saving context: \(error), \(error.userInfo)")
            }
        }
    }
}
