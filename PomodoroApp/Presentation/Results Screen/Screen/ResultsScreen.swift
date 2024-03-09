//
//  ResultsScreen.swift
//  PomodoroApp
//
//  Created by Петр Тартынских on 09.03.2024.
//

import SwiftUI
import Nivelir

struct ResultsScreen: Screen {
    
    let screens: Screens
    
    func build(navigator: ScreenNavigator) -> UIViewController {
        let viewModel = ResultsViewModel(
            navigator: navigator,
            screens: screens
        )
        let view = ResultsView(viewModel: viewModel)
        let controller = CustomHostingController(
            screenKey: key,
            rootView: view,
            onViewDidLoad: viewModel.viewDidLoad
        )
        
        controller.title = Strings.ResultsScreen.title
        
        return controller
    }
}
