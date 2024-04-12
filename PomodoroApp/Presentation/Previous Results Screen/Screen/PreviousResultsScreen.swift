//
//  PreviousResultsScreen.swift
//  PomodoroApp
//
//  Created by Петр Тартынских on 09.03.2024.
//

import SwiftUI
import Nivelir

struct PreviousResultsScreen: Screen {
    
    let screens: Screens
    
    func build(navigator: ScreenNavigator) -> UIViewController {
        let viewModel = PreviousResultsViewModel(
            navigator: navigator,
            screens: screens
        )
        let view = PreviousResultsView(viewModel: viewModel)
        let controller = CustomHostingController(
            screenKey: key,
            rootView: view,
            onViewDidAppear: viewModel.viewDidAppear
        )
        
        controller.title = Strings.PreviousResults.title
        viewModel.viewController = controller
        
        return controller
    }
}
