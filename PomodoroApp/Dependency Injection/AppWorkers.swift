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
        feedbackService: services.feedbackService,
        notificationService: services.notificationService,
        pomodoroService: services.pomodoroService,
        timerService: services.timerService,
        tasksStorage: storages.taskStorage
    )
    
    // MARK: - Private Properties
    
    private let services: AppServices
    private let storages: AppStorages
    
    // MARK: - Init
    
    init(
        services: AppServices,
        storages: AppStorages
    ) {
        self.services = services
        self.storages = storages
    }
}
