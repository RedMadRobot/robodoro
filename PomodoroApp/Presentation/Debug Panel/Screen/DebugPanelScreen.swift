//
//  DebugPanelScreen.swift
//  PomodoroApp
//
//  Created by Петр Тартынских on 08.03.2024.
//

import SwiftUI
import Nivelir

struct DebugPanelScreen: Screen {
    
    let screens: Screens
    
    func build(navigator: ScreenNavigator) -> UIViewController {
        let viewModel = DebugPanelViewModel(
            navigator: navigator,
            screens: screens
        )
        let view = DebugPanelView(viewModel: viewModel)
        let controller = CustomHostingController(
            screenKey: key,
            rootView: view
        )
        
        controller.title = Strings.DebugPanel.navigationTitle
        
        return controller
    }
}
