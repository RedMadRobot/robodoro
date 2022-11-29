//
//  AppWorkers.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 17.11.2022.
//

import Foundation

final class AppWorkers {
    
    // MARK: - Workers
    
    lazy var timedPomodoroWorker: TimedPomodoroWorker = TimedPomodoroWorkerImpl(
        activityService: services.activityService,
        notificationService: services.notificationService,
        pomodoroService: services.pomodoroService,
        timerService: services.timerService
    )
    
    // MARK: - Private Properties
    
    private let services: AppServices
    
    // MARK: - Init
    
    init(services: AppServices) {
        self.services = services
    }
}
