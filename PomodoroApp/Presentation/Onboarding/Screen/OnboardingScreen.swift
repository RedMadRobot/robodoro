//
//  OnboardingScreen.swift
//  PomodoroApp
//
//  Created by Петр Тартынских on 09.03.2024.
//

import Nivelir
import SwiftUI

struct OnboardingScreen: Screen {
    
    let screens: Screens
    
    func build(navigator: ScreenNavigator) -> UIViewController {
        let viewModel = OnboardingViewModel(
            navigator: navigator,
            screens: screens
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
