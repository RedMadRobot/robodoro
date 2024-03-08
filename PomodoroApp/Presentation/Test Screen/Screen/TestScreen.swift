//
//  TestScreen.swift
//  PomodoroApp
//
//  Created by Петр Тартынских on 07.03.2024.
//

import SwiftUI
import Nivelir

struct TestScreen: Screen {
    
    public var traits: Set<AnyHashable> {
        [numberOfScreen]
    }
    
    let numberOfScreen: Int
    let screens: Screens
    
    func build(navigator: ScreenNavigator) -> UIViewController {
        let viewModel = TestViewModel(
            numberOfScreen: numberOfScreen,
            navigator: navigator,
            screens: screens
        )
        let view = TestView(
            screenKey: key,
            viewModel: viewModel
        )
        let controller = UIHostingController(rootView: view)
        
        // TODO: - Узнать на проработке
//        let controller = DeclarativeController(
//            screenKey: key,
//            content: view
//        )
        
        controller.sizingOptions = .preferredContentSize
        viewModel.viewController = controller
        
        return controller
    }
}
