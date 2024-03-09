//
//  PomodoroApp.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 11.11.2022.
//

import SwiftUI

// TODO: - [2.0.0] В процессе перехода на новую систему навигации, в будущем будет удалено
//@main
struct PomodoroApp: App {
    
    // MARK: - Private Properties
    
    @StateObject
    private var navigator = MainNavigator()
    
    @Environment(\.scenePhase)
    private var scenePhase: ScenePhase
    
    private let timedPomodoroWorker: TimedPomodoroWorker
    
    // MARK: - Init
    
    init() {
        self.timedPomodoroWorker = DI.workers.timedPomodoroWorker
    }
    
    // MARK: - App
    
    var body: some Scene {
        WindowGroup {
            NavigationStack() {
                resultsView
            }
            .overlay(
                navigator.onboardingPresented ?
                onboardingView : nil)
            .onAppear {
                addObservers()
                navigator.resolveInitialNavigation()
                timedPomodoroWorker.requestNotificationPermissionIfNeeded()
                timedPomodoroWorker.stopActivityIfNeeded()
            }
            .onOpenURL { url in
                guard let action = LinkManager.manage(url: url) else { return }
                switch scenePhase {
                case .background:
                    timedPomodoroWorker.setLinkAction(action)
                case .inactive:
                    timedPomodoroWorker.handleLinkAction(action, navigator: navigator)
                default:
                    break
                }
            }
            .preferredColorScheme(.light)
        }
    }
    
    // MARK: - Private Properties
    
    @ViewBuilder
    private var resultsView: some View {
//        ResultsView(navigator: navigator)
        EmptyView()
            .sheet(
                isPresented: $navigator.previousResultsPresented,
                onDismiss: {
                    navigator.resolveDelayedNavigation()
                }
            ) {
                PreviousResultsView(navigator: navigator)
                    .interactiveDismissDisabled()
            }
            .sheet(
                isPresented: $navigator.setTaskSheetPresented,
                onDismiss: {
                    navigator.resolveDelayedNavigation()
                }
            ) {
                SetTaskView(navigator: navigator)
            }
            .fullScreenCover(isPresented: $navigator.pomodoroModalPresented) {
                pomodoroView
            }
    }
    
    @ViewBuilder
    private var pomodoroView: some View {
        PomodoroView(navigator: navigator)
    }
    
    @ViewBuilder
    private var onboardingView: some View {
        OnboardingView(navigator: navigator)
            .onDisappear {
                navigator.resolveDelayedNavigation()
            }
    }
    
    // MARK: - Private Methods
    
    private func addObservers() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.didEnterBackgroundNotification,
            object: nil,
            queue: .main)
        { _ in
            applicationDidEnterBackground()
        }

        NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: .main)
        { _ in
            applicationWillEnterForeground()
        }
    }
    
    private func applicationDidEnterBackground() {
        print("BACKGROUND")
        guard navigator.pomodoroModalPresented else { return }
        timedPomodoroWorker.handleEnterBackground()
    }

    private func applicationWillEnterForeground() {
        print("FOREGROUND")
        guard navigator.pomodoroModalPresented else { return }
        timedPomodoroWorker.handleEnterForeground(navigator: navigator)
    }
}
