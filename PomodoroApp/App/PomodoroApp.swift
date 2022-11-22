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
    private var pomodoroViewModel = PomodoroViewModel()
    
    private let timedPomodoroWorker: TimedPomodoroWorker
    
    // MARK: - Init
    
    init() {
        self.timedPomodoroWorker = DI.workers.timedPomodoroWorker
        addObservers()
    }
    
    // MARK: - App
    
    var body: some Scene {
        WindowGroup {
            PomodoroView(viewModel: pomodoroViewModel)
                .preferredColorScheme(.light)
                .onOpenURL { url in
                    guard case .mainButtonAction = LinkManager.manage(url: url) else { return }
                    timedPomodoroWorker.mainAction()
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
            applicationWillTerminate()
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
    
    private func applicationWillTerminate() {
        timedPomodoroWorker.reset()
    }
    
    private func applicationDidEnterBackground() {
        timedPomodoroWorker.handleEnterBackground()
    }
    
    private func applicationWillEnterForeground() {
        timedPomodoroWorker.handleEnterForeground()
    }
}
