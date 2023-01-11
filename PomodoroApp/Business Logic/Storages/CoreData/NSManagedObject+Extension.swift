//
//  NSManagedObject+Extension.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 11.01.2023.
//

import CoreData

extension NSManagedObjectContext {
    
    func saveIfNeeded() {
        if hasChanges {
            do {
                try save()
            } catch let error as NSError {
                NSLog("Unresolved error saving context: \(error), \(error.userInfo)")
            }
        }
    }
    
    func fetchFirst<T: NSManagedObject>(_ objectType: T.Type, predicate: NSPredicate?) -> Result<T?, Error> {
        let request = objectType.fetchRequest()
        request.predicate = predicate
        request.fetchLimit = 1
        do {
            let result = try fetch(request) as? [T]
            return .success(result?.first)
        } catch {
            return .failure(error)
        }
    }
}
