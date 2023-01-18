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

enum DelayedPresentingScreen {
    case pomodoro
    case previousResults
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
    var onboardingPresented: Bool
    
    @Published
    var alertPresented = false
    private(set) var alertViewModel = AlertViewModel()
        
    // Используется при показе алертов
    var rootIsVisible: Bool {
        !pomodoroModalPresented && !setTaskSheetPresented && !previousResultsPresented && !onboardingPresented
    }
    
    // MARK: - Private Properties
    
    private var screenToPresent: DelayedPresentingScreen?
    
    private var userDefaultsStorage: OnboardingStorage
    
    // MARK: - Init
    
    init(userDefaultsStorage: OnboardingStorage = DI.storages.userDefaultsStorage) {
        self.userDefaultsStorage = userDefaultsStorage
        
        self.onboardingPresented = !userDefaultsStorage.onboadingShowed
    }
    
    // MARK: - Public Methods
    
    func pop() {
        navigationPath.removeLast()
    }
    
    func pushSettings() {
        navigationPath.append(StackScreen.settings)
    }
    
    func showPomodoroModal(delayed: Bool = false) {
        if delayed {
            screenToPresent = .pomodoro
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
    
    func showPreviousResultsSheet(delayed: Bool = false) {
        if delayed {
            screenToPresent = .previousResults
        } else {
            previousResultsPresented = true
        }
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
    
    func hideOnboarding() {
        onboardingPresented = false
        userDefaultsStorage.onboadingShowed = true
    }
    
    func resolveDelayedNavigation() {
        switch screenToPresent {
        case .pomodoro:
            showPomodoroModal()
        case .previousResults:
            showPreviousResultsSheet()
        default:
            break
        }
        screenToPresent = nil
    }
}
