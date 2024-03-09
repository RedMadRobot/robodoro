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
    
    private let scenarioResolver: ScenarioResolver
    
    // MARK: - Public Properties
    
    @Published
    private(set) var whoWeAreIsVisible: Bool = true
    
    private(set) var feedbackService: FeedbackService
    
    // MARK: - Init
    
    init(
        navigator: ScreenNavigator,
        screens: Screens,
        feedbackService: FeedbackService = DI.services.feedbackService,
        scenarioResolver: ScenarioResolver = ScenarioResolver()
    ) {
        self.navigator = navigator
        self.screens = screens
        self.feedbackService = feedbackService
        self.scenarioResolver = scenarioResolver
    }
    
    func whoWeAreViewButtonTapped() {
        whoWeAreIsVisible = false
    }
    
    func onboardingButtonTapped() {
        scenarioResolver.onboardingCompleted()
        navigator.navigate { route in
            route
                .top(.container)
                .presenting
                .dismiss()
        }
    }
}
