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
    }
    
    private func applicationWillTerminate() {
        timedPomodoroWorker.reset()
    }
}
