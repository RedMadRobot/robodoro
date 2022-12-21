//
//  FeedbackService.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 29.11.2022.
//

import AVFoundation
import UIKit

// MARK: - FeedbackService

protocol FeedbackService {
    func playTimerEndSignal()
    func performImpact()
}

// MARK: - FeedbackServiceImpl

final class FeedbackServiceImpl: FeedbackService {

    // MARK: - Constants
    
    private enum Constants {
        static let alarmUrl = "/System/Library/Audio/UISounds/alarm.caf"
        static let alarmId: SystemSoundID = 1304
        static let vibrationId: SystemSoundID = 4095
    }
    
    // MARK: - Private Properties
    
    private let userDefaultsStorage: UserDefaultsStorage
    
    private let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    // MARK: - Init
    
    init(userDefaultsStorage: UserDefaultsStorage) {
        self.userDefaultsStorage = userDefaultsStorage
    }
    
    // MARK: - Public Methods
    
    func playTimerEndSignal() {
        if userDefaultsStorage.soundEnabled {
            var alarmId = Constants.alarmId
            let url = URL(fileURLWithPath: Constants.alarmUrl)
            AudioServicesCreateSystemSoundID(url as CFURL, &alarmId)
            AudioServicesPlaySystemSound(alarmId)
        }
        
        if userDefaultsStorage.hapticEnabled {
            AudioServicesPlaySystemSound(Constants.vibrationId)
        }
    }
    
    func performImpact() {
        if userDefaultsStorage.hapticEnabled {
            impactFeedbackGenerator.impactOccurred()
        }
    }
}
