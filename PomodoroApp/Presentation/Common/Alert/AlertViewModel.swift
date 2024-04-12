//
//  AlertViewModel.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 21.12.2022.
//

import SwiftUI

// MARK: - AlertState

enum AlertState {
    case noAlert
    case presenting(AlertViewModel)
}

// MARK: - AlertViewModel

final class AlertViewModel: ViewModel {
    
    // MARK: - Private properties
    
    private let primaryAction: (() -> Void)
    private let secondaryAction: (() -> Void)
    private let commonCompletion: (() -> Void)
    
    // MARK: - Public Properties
    
    let title: String
    let primaryButtonTitle: String
    let secondaryButtonTitle: String
    
    private(set) var feedbackService: FeedbackService
        
    // MARK: - Init
    
    init(
        title: String,
        primaryButtonTitle: String,
        secondaryButtonTitle: String,
        primaryAction: @escaping () -> Void = {},
        secondaryAction: @escaping () -> Void = {},
        commonCompletion: @escaping () -> Void = {},
        feedbackService: FeedbackService = DI.services.feedbackService
    ) {
        self.title = title
        self.primaryButtonTitle = primaryButtonTitle
        self.secondaryButtonTitle = secondaryButtonTitle
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.commonCompletion = commonCompletion
        self.feedbackService = feedbackService
    }
    
    // MARK: - Public methdos
    
    func primaryButtonTapped() {
        primaryAction()
        commonCompletion()
    }
    
    func secondaryButtonTapped() {
        secondaryAction()
        commonCompletion()
    }
}
