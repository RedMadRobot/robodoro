//
//  PomodoroApp.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 11.11.2022.
//

import SwiftUI

@main
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
            NavigationStack(path: $navigator.navigationPath) {
                resultsView
                    .navigationDestination(for: StackScreen.self) { screen in
                        switch screen {
                        case .settings:
                            SettingsView(navigator: navigator)
                        }
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
                            .overlay(navigator.alertPresented ? AlertView(navigator: navigator) : nil)
                    }
            }
            .overlay(
                navigator.alertPresented && navigator.rootIsVisible ?
                AlertView(navigator: navigator) : nil)
        }
    }
    
    // MARK: - Private Properties
    
    @ViewBuilder
    private var resultsView: some View {
        ResultsView(navigator: navigator)
            .preferredColorScheme(.light)
            .onAppear {
                timedPomodoroWorker.requestNotificationPermissionIfNeeded()
            }
    }
    
    @ViewBuilder
    private var pomodoroView: some View {
        PomodoroView(navigator: navigator)
            .onAppear {
                addObservers()
            }
            .onDisappear {
                removeObservers()
                resetPomodoroWorker()
            }
            .onOpenURL { url in
                guard let action = LinkManager.manage(url: url) else { return }
                switch scenePhase {
                case .background:
                    timedPomodoroWorker.setLinkAction(action)
                case .inactive:
                    timedPomodoroWorker.handleLinkAction(action)
                default:
                    break
                }
            }
    }
    
    // MARK: - Private Methods
    
    private func addObservers() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.willTerminateNotification,
            object: nil,
            queue: .main
        ) { _ in
            resetPomodoroWorker()
        }

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

    private func removeObservers() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIApplication.willTerminateNotification,
            object: nil)
        
        NotificationCenter.default.removeObserver(
            self,
            name: UIApplication.didEnterBackgroundNotification,
            object: nil)
        
        NotificationCenter.default.removeObserver(
            self,
            name: UIApplication.willEnterForegroundNotification,
            object: nil)
    }
    
    private func resetPomodoroWorker() {
        timedPomodoroWorker.reset()
        timedPomodoroWorker.cancelNotification()
    }

    private func applicationDidEnterBackground() {
        timedPomodoroWorker.handleEnterBackground()
    }

    private func applicationWillEnterForeground() {
        timedPomodoroWorker.handleEnterForeground()
    }
}
