//
//  AppServices.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 15.11.2022.
//

import Foundation

final class AppServices {
    
    lazy var activityService: LiveActivityService = LiveActivityServiceImpl()
    lazy var feedbackService: FeedbackService = FeedbackServiceImpl(userDefaultsStorage: storages.userDefaultsStorage)
    lazy var dateCalculatorService: DateCalculatorService = DateCalculatorServiceImpl()
    lazy var notificationService: NotificationService = NotificationServiceImpl()
    lazy var pomodoroService: PomodoroService = PomodoroServiceImpl()
    lazy var timerService: TimerService = TimerServiceImpl()
    
    // MARK: - Private Properties

    private let storages: AppStorages
    
    // MARK: - Initialisers
    
    init(storages: AppStorages) {
        self.storages = storages
    }
}
