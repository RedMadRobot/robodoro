//
//  SettingsViewModel.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 14.12.2022.
//

import Nivelir
import SwiftUI

final class SettingsViewModel: ViewModel {
    
    // MARK: - Private Properties
    
    private let navigator: ScreenNavigator
    private let screens: Screens
    
    private var userDefaultsStorage: SettingsStorage
    
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
        
    // MARK: - Init
    
    init(
        navigator: ScreenNavigator,
        screens: Screens,
        userDefaultsStorage: SettingsStorage = DI.storages.userDefaultsStorage,
        feedbackService: FeedbackService = DI.services.feedbackService
    ) {
        self.navigator = navigator
        self.screens = screens
        self.userDefaultsStorage = userDefaultsStorage
        self.feedbackService = feedbackService
        self.soundEnabled = userDefaultsStorage.soundEnabled
        self.hapticEnabled = userDefaultsStorage.hapticEnabled
    }
    
    // MARK: - Public methods
    
    func moveToDebugPanelTapped() {
        navigator.navigate { route in
            route
                .top(.stack)
                .push(screens.debugPanelScreen())
        }
    }
}
