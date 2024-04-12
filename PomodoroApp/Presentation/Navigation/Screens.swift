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
    
    func setTaskScreen() -> AnyModalScreen {
        SetTaskScreen(screens: self)
            .eraseToAnyScreen()
    }
    
    func pomodoroScreen() -> AnyModalScreen {
        PomodoroScreen(screens: self)
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
    
    // MARK: - Routes
    
    func showResultsRoute() -> ScreenWindowRoute {
        ScreenWindowRoute()
            .setRoot(
                to: resultsScreen()
                    .withStackContainer(of: CustomStackController.self)
            )
            .makeKeyAndVisible()
    }
}
