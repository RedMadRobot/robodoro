//
//  MainNavigator.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 12.12.2022.
//

import SwiftUI

enum StackScreen: Hashable {
    case settings
}

enum ModalScreen {
    case pomodoro
}

final class MainNavigator: ObservableObject {
    
    // MARK: - Public Properties
    
    @Published
    var navigationPath = NavigationPath()
    
    @Published
    var pomodoroModalPresented = false
    
    @Published
    var setTaskSheetPresented = false
    
    // MARK: - Private Properties
    
    private var modalToPresent: ModalScreen?
        
    // MARK: - Public Methods
    
    func pop() {
        navigationPath.removeLast()
    }
    
    func popToRoot() {
        navigationPath.removeLast(navigationPath.count)
    }
    
    func pushSettings() {
        navigationPath.append(StackScreen.settings)
    }
    
    func prepareShowModal() {
        
    }
    
    func showPomodoroModal(delayed: Bool = false) {
        if delayed {
            modalToPresent = .pomodoro
        } else {
            pomodoroModalPresented = true
        }
    }
    
    func hidePomodoroModal() {
        pomodoroModalPresented = false
    }
    
    func showSetTaskSheet() {
        setTaskSheetPresented = true
    }
    
    func hideSetTaskSheet() {
        setTaskSheetPresented = false
    }
    
    func resolveDelayedNavigation() {
        switch modalToPresent {
        case .pomodoro:
            showPomodoroModal()
        default:
            break
        }
        modalToPresent = nil
    }
}
