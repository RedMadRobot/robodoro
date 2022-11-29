//
//  NotificationService.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 25.11.2022.
//

import UserNotifications

// MARK: - NotificationService

protocol NotificationService {
    func requestPermissionIfNeeded()
    func scheduleNotification(in timeInterval: TimeInterval, title: String, body: String)
    func cancelPendingNotification()
}

// MARK: - NotificationServiceImpl

final class NotificationServiceImpl: NotificationService {
    
    // MARK: - Private Properties
    
    private let userNotificationCenter: UNUserNotificationCenter
    
    // MARK: - Init
    
    init(userNotificationCenter: UNUserNotificationCenter = .current()) {
        self.userNotificationCenter = userNotificationCenter
    }
    
    // MARK: - Public Methods
    
    func requestPermissionIfNeeded() {
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        userNotificationCenter.requestAuthorization(options: authOptions) { success, error in
            if let error = error {
                print("Error: ", error)
            }
        }
    }
    
    func scheduleNotification(
        in timeInterval: TimeInterval,
        title: String,
        body: String
    ) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger)
        
        userNotificationCenter.add(request)
    }
    
    func cancelPendingNotification() {
        userNotificationCenter.removeAllPendingNotificationRequests()
    }
}
