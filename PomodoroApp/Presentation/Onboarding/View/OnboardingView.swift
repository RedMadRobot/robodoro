//
//  OnboardingView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 18.01.2023.
//

import Nivelir
import SwiftUI

struct OnboardingView: View {
    
    // MARK: - Private Properties
    
    @ObservedObject
    private var viewModel: OnboardingViewModel
    
    // MARK: - Init
    
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - View
    
    var body: some View {
        InfoOverlayView(
            onButtonTapped: viewModel.onboardingButtonTapped
        )
        .overlay(
            viewModel.whoWeAreIsVisible ?
            WhoAreWeView(
                onButtonTapped: viewModel.whoWeAreViewButtonTapped
            ) : nil
        )
    }
    
    // MARK: - PrivateProperties
}

// MARK: - PreviewProvider

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(
            viewModel: OnboardingViewModel(
                navigator: ScreenNavigator(window: UIWindow()),
                screens: Screens()
            )
        )
    }
}
