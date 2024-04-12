//
//  SettingsScreen.swift
//  PomodoroApp
//
//  Created by Петр Тартынских on 08.03.2024.
//

import SwiftUI
import Nivelir

struct SettingsScreen: Screen {
    
    let screens: Screens
    
    func build(navigator: ScreenNavigator) -> UIViewController {
        let viewModel = SettingsViewModel(
            navigator: navigator,
            screens: screens
        )
        let view = SettingsView(viewModel: viewModel)
        let controller = CustomHostingController(
            screenKey: key,
            rootView: view
        )
        
        controller.title = Strings.Settings.title
        
        return controller
    }
}
