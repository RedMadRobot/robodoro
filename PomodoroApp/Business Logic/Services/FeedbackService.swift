//
//  FeedbackService.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 29.11.2022.
//

import AVFoundation
import CoreHaptics

// MARK: - FeedbackService

protocol FeedbackService {
    func playTimerEndSignal()
}

// MARK: - FeedbackServiceImpl

final class FeedbackServiceImpl: FeedbackService {
        
    // MARK: - Public Methods
    
    func playTimerEndSignal() {
        let systemSoundID: SystemSoundID = 1304
        AudioServicesPlayAlertSound(systemSoundID)
    }
}
