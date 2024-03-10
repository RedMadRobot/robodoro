//
//  PomodoroScreen.swift
//  PomodoroApp
//
//  Created by Петр Тартынских on 10.03.2024.
//

import SwiftUI
import Nivelir

struct PomodoroScreen: Screen {
    
    let screens: Screens
    
    func build(navigator: ScreenNavigator) -> UIViewController {
        let viewModel = PomodoroViewModel(
            navigator: navigator,
            screens: screens
        )
        let view = PomodoroView(viewModel: viewModel)
        let controller = CustomHostingController(
            screenKey: key,
            rootView: view
        )
                
        return controller
    }
}
