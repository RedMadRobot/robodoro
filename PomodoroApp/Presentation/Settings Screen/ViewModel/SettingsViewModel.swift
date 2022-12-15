//
//  SettingsViewModel.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 14.12.2022.
//

import SwiftUI

final class SettingsViewModel: ViewModel {
    
    // MARK: - Public Properties
    
    @Published
    var soundEnabled: Bool {
        didSet {
            userDefaultsStorage.soundEnabled = soundEnabled
            performImpact()
        }
    }
    
    @Published
    var hapticEnabled: Bool {
        didSet {
            userDefaultsStorage.hapticEnabled = hapticEnabled
            performImpact()
        }
    }
    
    private(set) var feedbackService: FeedbackService
    
    // MARK: - Private Properties
    
    private let userDefaultsStorage: UserDefaultsStorage
        
    // MARK: - Init
    
    init(
        userDefaultsStorage: UserDefaultsStorage = DI.storages.userDefaultsStorage,
        feedbackService: FeedbackService = DI.services.feedbackService
    ) {
        self.userDefaultsStorage = userDefaultsStorage
        self.feedbackService = feedbackService
        self.soundEnabled = userDefaultsStorage.soundEnabled
        self.hapticEnabled = userDefaultsStorage.hapticEnabled
    }
}
