//
//  OnboardingScreen.swift
//  PomodoroApp
//
//  Created by Петр Тартынских on 09.03.2024.
//

import Nivelir
import SwiftUI

// MARK: - OnboardingScreenDelegate

protocol OnboardingScreenDelegate: AnyObject {
    func onboardingCompleted()
}

struct OnboardingScreen: Screen {
    
    let screens: Screens
    
    weak var delegate: OnboardingScreenDelegate?
    
    func build(navigator: ScreenNavigator) -> UIViewController {
        let viewModel = OnboardingViewModel(
            navigator: navigator,
            screens: screens,
            delegate: delegate
        )
        let view = OnboardingView(viewModel: viewModel)
        let controller = CustomHostingController(
            screenKey: key,
            rootView: view
        )
        
        controller.view.backgroundColor = .clear
        
        return controller
    }
}
