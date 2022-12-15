//
//  ViewModel.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 15.12.2022.
//

import SwiftUI

protocol ViewModel: ObservableObject {
    
    var feedbackService: FeedbackService { get }
    
    func performImpact()
}

extension ViewModel {
    
    func performImpact() {
        feedbackService.performImpact()
    }
}
