//
//  SetTaskScreen.swift
//  PomodoroApp
//
//  Created by Петр Тартынских on 10.03.2024.
//

import SwiftUI
import Nivelir

struct SetTaskScreen: Screen {
    
    let screens: Screens
    
    func build(navigator: ScreenNavigator) -> UIViewController {
        let viewModel = SetTaskViewModel(
            navigator: navigator,
            screens: screens
        )
        let view = SetTaskView(viewModel: viewModel)
        let controller = CustomHostingController(
            screenKey: key,
            rootView: view
        )
        
        controller.title = Strings.SetTask.title
        
        return controller
    }
}
