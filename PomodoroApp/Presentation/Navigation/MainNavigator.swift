//
//  MainNavigator.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 12.12.2022.
//

import SwiftUI

enum Screen: Hashable {
    case settings
}

final class MainNavigator: ObservableObject {
    
    // MARK: - Public Properties
    
    @Published
    var navigationPath = NavigationPath()
    
    @Published
    var showPomodoroCover = false
    
    // MARK: - Public Methods
    
    func pop() {
        navigationPath.removeLast()
    }
    
    func popToRoot() {
        navigationPath.removeLast(navigationPath.count)
    }
    
    func pushSettings() {
        navigationPath.append(Screen.settings)
    }
    
    func showPomodoro() {
        showPomodoroCover = true
    }
    
    func hidePomodoro() {
        showPomodoroCover = false
    }
}
