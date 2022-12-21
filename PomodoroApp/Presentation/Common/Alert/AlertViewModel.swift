//
//  AlertViewModel.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 21.12.2022.
//

import SwiftUI

final class AlertViewModel: ViewModel {
    
    // MARK: - Public Properties
    
    @Published
    private(set) var title: String = ""
    
    @Published
    private(set) var primaryButtonTitle: String = ""
    
    @Published
    private(set) var secondaryButtonTitle: String = ""
    
    private(set) var primaryAction: (() -> Void)?
    private(set) var secondaryAction: (() -> Void)?
    private(set) var commonCompletion: (() -> Void)?
    
    
    private(set) var feedbackService: FeedbackService
    
    // MARK: - Private Propreties
    
    // MARK: - Init
    
    init(
        feedbackService: FeedbackService = DI.services.feedbackService
    ) {
        self.feedbackService = feedbackService
    }
    
    // MARK: - Public Methods
    
    func setup(
        title: String,
        primaryButtonTitle: String,
        secondaryButtonTitle: String,
        primaryAction: (() -> Void)?,
        secondaryAction: (() -> Void)?,
        commonCompletion: (() -> Void)?
    ) {
        self.title = title
        self.primaryButtonTitle = primaryButtonTitle
        self.secondaryButtonTitle = secondaryButtonTitle
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.commonCompletion = commonCompletion
    }
}
