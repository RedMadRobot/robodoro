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
    
    func testScreen(numberOfScreen: Int) -> AnyModalScreen {
        TestScreen(
            numberOfScreen: numberOfScreen,
            screens: self
        )
        .eraseToAnyScreen()
    }
    
    // MARK: - Routes
    
    func showTestRoute() -> ScreenWindowRoute {
        ScreenWindowRoute()
            .setRoot(
                to: testScreen(
                    numberOfScreen: 0
                )
                .withStackContainer())
            .makeKeyAndVisible()
    }
}
