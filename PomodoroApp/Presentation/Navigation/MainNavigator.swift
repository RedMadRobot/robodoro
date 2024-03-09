//
//  MainNavigator.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 12.12.2022.
//

import SwiftUI

// TODO: - [2.0.0] В процессе перехода на новую систему навигации, в будущем будет удалено

enum DelayedPresentingScreen {
    case pomodoro
    case previousResults
}

final class MainNavigator: ObservableObject {
    
    // MARK: - Public Properties
    
    @Published
    var pomodoroModalPresented = false
    
    @Published
    var setTaskSheetPresented = false
    
    @Published
    var previousResultsPresented = false
        
    var rootIsVisible: Bool {
        !pomodoroModalPresented &&
        !setTaskSheetPresented &&
        !previousResultsPresented
    }
    
    // MARK: - Private Properties
    
    private let scenarioResolver: ScenarioResolver
    
    private var screensToPresent: [DelayedPresentingScreen] = []
    
    // MARK: - Init
    
    init(scenarioResolver: ScenarioResolver = ScenarioResolver()) {
        self.scenarioResolver = scenarioResolver
    }
    
    // MARK: - Public Methods
    
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
    
    func resolveInitialNavigation() {
//        if scenarioResolver.shouldShowOnboarding {
//            showOnboarding()
//        }
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
