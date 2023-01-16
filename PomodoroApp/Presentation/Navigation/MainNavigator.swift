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
    
    @Published
    var previousResultsPresented = false
    
    @Published
    var alertPresented = false
    private(set) var alertViewModel = AlertViewModel()
        
    var rootIsVisible: Bool {
        !pomodoroModalPresented && !setTaskSheetPresented
    }
    
    // MARK: - Private Properties
    
    private var modalToPresent: ModalScreen?
        
    // MARK: - Public Methods
    
    func pop() {
        navigationPath.removeLast()
    }
    
    func pushSettings() {
        navigationPath.append(StackScreen.settings)
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
    
    func showPreviousResultsSheet() {
        previousResultsPresented = true
    }
    
    func hidePreviousResultsSheet() {
        previousResultsPresented = false
    }
    
    func showAlert(
        title: String,
        primaryButtonTitle: String,
        secondaryButtonTitle: String,
        primaryAction: (() -> Void)? = nil,
        secondaryAction: (() -> Void)? = nil,
        commonCompletion: (() -> Void)? = nil
    ) {
        alertViewModel.setup(
            title: title,
            primaryButtonTitle: primaryButtonTitle,
            secondaryButtonTitle: secondaryButtonTitle,
            primaryAction: primaryAction,
            secondaryAction: secondaryAction,
            commonCompletion: commonCompletion)
        alertPresented = true
    }
    
    func hideAlert() {
        alertPresented = false
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
