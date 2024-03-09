//
//  OnboardingViewModel.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 18.01.2023.
//

import Nivelir
import SwiftUI

final class OnboardingViewModel: ViewModel {
    
    // MARK: - Private properties
    
    private let navigator: ScreenNavigator
    private let screens: Screens
    
    private var userDefaultsStorage: OnboardingStorage
    
    // MARK: - Public Properties
    
    @Published
    private(set) var whoWeAreIsVisible: Bool = true
    
    private(set) var feedbackService: FeedbackService
    
    // MARK: - Init
    
    init(
        navigator: ScreenNavigator,
        screens: Screens,
        userDefaultsStorage: OnboardingStorage = DI.storages.userDefaultsStorage,
        feedbackService: FeedbackService = DI.services.feedbackService
    ) {
        self.navigator = navigator
        self.screens = screens
        self.userDefaultsStorage = userDefaultsStorage
        self.feedbackService = feedbackService
    }
    
    func whoWeAreViewButtonTapped() {
        whoWeAreIsVisible = false
    }
    
    func onboardingButtonTapped() {
        userDefaultsStorage.onboadingShowed = true
        navigator.navigate { route in
            route
                .top(.container)
                .presenting
                .dismiss()
        }
    }
}
