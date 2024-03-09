//
//  Screens.swift
//  PomodoroApp
//
//  Created by Петр Тартынских on 07.03.2024.
//

import Foundation
import Nivelir

struct Screens {
    
    // MARK: - Screens
    
    func resultsScreen() -> AnyModalScreen {
        ResultsScreen(screens: self)
            .eraseToAnyScreen()
    }
    
    func previousResultsScreen() -> AnyModalScreen {
        PreviousResultsScreen(screens: self)
            .eraseToAnyScreen()
    }
    
    func onboardingScreen(delegate: OnboardingScreenDelegate?) -> AnyModalScreen {
        OnboardingScreen(
            screens: self,
            delegate: delegate
        )
            .eraseToAnyScreen()
    }
    
    func settingsScreen() -> AnyModalScreen {
        SettingsScreen(screens: self)
            .eraseToAnyScreen()
    }
    
    func debugPanelScreen() -> AnyModalScreen {
        DebugPanelScreen(screens: self)
            .eraseToAnyScreen()
    }
    
    func testScreen(numberOfScreen: Int) -> AnyModalScreen {
        TestScreen(
            numberOfScreen: numberOfScreen,
            screens: self
        )
        .eraseToAnyScreen()
    }
    
    // MARK: - Routes
    
    func showResultsRoute() -> ScreenWindowRoute {
        ScreenWindowRoute()
            .setRoot(
                to: resultsScreen()
                    .withStackContainer(of: CustomStackController.self)
            )
            .makeKeyAndVisible()
    }
    
    func showTestRoute() -> ScreenWindowRoute {
        ScreenWindowRoute()
            .setRoot(
                to: testScreen(
                    numberOfScreen: 0
                )
                .withStackContainer(of: CustomStackController.self)
            )
            .makeKeyAndVisible()
    }
}
