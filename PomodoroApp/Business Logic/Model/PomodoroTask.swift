//
//  PomodoroTask.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 19.12.2022.
//

import Foundation

struct PomodoroTask: Equatable {
    let id: UUID
    let title: String?
    let date: Date
    var completedInterval: TimeInterval
}

extension PomodoroTask {
    
    init?(coreDataObject: PomodoroTaskObject) {
        guard let id = coreDataObject.id,
              let date = coreDataObject.date else { return nil }
        
        self.id = id
        self.title = coreDataObject.title
        self.date = date
        self.completedInterval = coreDataObject.completedInterval
    }
}
