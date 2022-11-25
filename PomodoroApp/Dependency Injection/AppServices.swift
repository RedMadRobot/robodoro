//
//  AppServices.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 15.11.2022.
//

import Foundation

final class AppServices {
    lazy var activityService: LiveActivityService = LiveActivityServiceImpl()
    lazy var notificationService: NotificationService = NotificationServiceImpl()
    lazy var pomodoroService: PomodoroService = PomodoroServiceImpl()
    lazy var timerService: TimerService = TimerServiceImpl()
}
