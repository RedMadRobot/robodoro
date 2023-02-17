//
//  MainNavigator.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 12.12.2022.
//

import SwiftUI

enum StackScreen: Hashable {
    case settings
    case debugPanel
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
    var onboardingPresented: Bool = false
    
    @Published
    var alertPresented = false
    private(set) var alertViewModel = AlertViewModel()
        
    var rootIsVisible: Bool {
        !pomodoroModalPresented &&
        !setTaskSheetPresented &&
        !previousResultsPresented &&
        !onboardingPresented &&
        navigationPath.isEmpty
    }
    
    // MARK: - Private Properties
    
    private let scenarioResolver: ScenarioResolver
    
    private var screensToPresent: [DelayedPresentingScreen] = []
    
    // MARK: - Init
    
    init(scenarioResolver: ScenarioResolver = ScenarioResolver()) {
        self.scenarioResolver = scenarioResolver
    }
    
    // MARK: - Public Methods
    
    func pop() {
        navigationPath.removeLast()
    }
    
    func pushSettings() {
        navigationPath.append(StackScreen.settings)
    }
    
    func pushDebugPanel() {
        navigationPath.append(StackScreen.debugPanel)
    }
    
    func showPomodoroModal(delayed: Bool = false) {
        if delayed {
            screensToPresent.insert(.pomodoro, at: 0)
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
            screensToPresent.insert(.previousResults, at: 0)
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
    
    func showOnboarding() {
        onboardingPresented = true
    }
    
    func hideOnboarding() {
        onboardingPresented = false
        scenarioResolver.onboardingCompleted()
    }
    
    func resolveInitialNavigation() {
        if scenarioResolver.shouldShowOnboarding {
            showOnboarding()
        }
        if scenarioResolver.shouldShowPreviousResults {
            showPreviousResultsSheet(delayed: !rootIsVisible)
        }
        if scenarioResolver.shouldShowPomodoro {
            scenarioResolver.setupPomodoroFromSavedData()
            showPomodoroModal(delayed: !rootIsVisible)
        }
    }
    
    func resolveDelayedNavigation() {
        switch screensToPresent.popLast() {
        case .pomodoro:
            guard scenarioResolver.readyToResumeTask else { return }
            showPomodoroModal()
        case .previousResults:
            showPreviousResultsSheet()
        default:
            break
        }
    }
}
