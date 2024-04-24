//
//  AppDelegate.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 22.01.2024.
//

import UIKit
import Nivelir

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var navigator: ScreenNavigator?
    let screens = Screens()
        
    private var timedPomodoroWorker: TimedPomodoroWorker?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        print("LAUNCHED")
        let window = UIWindow(frame: UIScreen.main.bounds)
        let navigator = ScreenNavigator(window: window, logger: .none)
        
        self.window = window
        self.navigator = navigator
        self.timedPomodoroWorker = DI.workers.timedPomodoroWorker
        
        navigator.navigate(to: screens.showResultsRoute())
        
        timedPomodoroWorker?.handleEnterForeground()
        
        return true
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        guard let action = LinkManager.getAction(from: url) else { return false }
        print("HANDLE ACTION \(action)")

        self.timedPomodoroWorker?.handleLinkAction(action) {
            self.dismissPomodoroScreen()
        }
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("BACKGROUND")
        
        timedPomodoroWorker?.handleEnterBackground()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("FOREGROUND")
        
        timedPomodoroWorker?.handleEnterForeground()
    }
    
    // MARK: - Private methods
    
    private func dismissPomodoroScreen() {
        let pomodoroScreen = screens.pomodoroScreen()
        navigator?.navigate(
            to: { route in
                route
                    .top(.container(of: pomodoroScreen))
                    .presenting
                    .dismiss()
            }
        )
    }
}

