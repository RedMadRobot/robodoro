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
    
    private weak var delegate: OnboardingScreenDelegate?
    
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
        scenarioResolver: ScenarioResolver = ScenarioResolver(),
        delegate: OnboardingScreenDelegate? = nil
    ) {
        self.navigator = navigator
        self.screens = screens
        self.feedbackService = feedbackService
        self.scenarioResolver = scenarioResolver
        self.delegate = delegate
    }
    
    func whoWeAreViewButtonTapped() {
        whoWeAreIsVisible = false
    }
    
    func onboardingButtonTapped() {
        scenarioResolver.onboardingCompleted()
        navigator.navigate(
            to: { route in
                route
                    .top(.container)
                    .presenting
                    .dismiss()
            },
            completion: { [weak self] result in
                self?.delegate?.onboardingCompleted()
            }
        )
    }
}
