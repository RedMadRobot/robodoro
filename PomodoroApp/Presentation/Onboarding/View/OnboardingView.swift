//
//  OnboardingView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 18.01.2023.
//

import SwiftUI

struct OnboardingView: View {
    
    // MARK: - Private Properties
    
    @StateObject
    private var viewModel = OnboardingViewModel()
    
    @ObservedObject
    private var navigator: MainNavigator
    
    // MARK: - Init
    
    init(navigator: MainNavigator) {
        self.navigator = navigator
    }
    
    // MARK: - View
    
    var body: some View {
        InfoOverlayView(onButtonClick: {
            navigator.hideOnboarding()
        })
        .overlay(
            viewModel.whoWeAreIsVisible ?
            WhoAreWeView(onButtonClick: {
                viewModel.hideWhoWeAre()
            }) : nil
        )
        .zIndex(1) // Без этого анимация не работает
    }
    
    // MARK: - PrivateProperties
}

// MARK: - PreviewProvider

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(navigator: MainNavigator())
    }
}
