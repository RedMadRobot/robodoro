//
//  OnboardingViewModel.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 18.01.2023.
//

import SwiftUI

final class OnboardingViewModel: ViewModel {
    
    // MARK: - Public Properties
    
    @Published
    private(set) var whoWeAreIsVisible: Bool = true
    
    private(set) var feedbackService: FeedbackService
    
    // MARK: - Init
    
    init(feedbackService: FeedbackService = DI.services.feedbackService) {
        self.feedbackService = feedbackService
    }
    
    func hideWhoWeAre() {
        whoWeAreIsVisible = false
    }
}
