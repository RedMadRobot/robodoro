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
    
    var delayedEnterForegroundAction: (() -> Void)?
    
    private var timedPomodoroWorker: TimedPomodoroWorker?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let navigator = ScreenNavigator(window: window, logger: .none)
        
        self.window = window
        self.navigator = navigator
        self.timedPomodoroWorker = DI.workers.timedPomodoroWorker
        
        navigator
            .navigate(to: screens.showTestRoute())
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        guard let action = LinkManager.getAction(from: url) else { return false }
        print("HANDLE ACTION \(action)")

        switch app.applicationState {
        case .inactive:
            delayedEnterForegroundAction = {
                self.timedPomodoroWorker?.handleLinkAction(action) {
                    self.dismissPomodoroScreen()
                }
            }
        case .background:
            delayedEnterForegroundAction = {
                self.timedPomodoroWorker?.setLinkAction(action)
            }
        default:
            break
        }
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("BACKGROUND")
        
        performIfPomodoroScreenFound {
            self.timedPomodoroWorker?.handleEnterBackground()
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("FOREGROUND")
        
        delayedEnterForegroundAction = {
            self.performIfPomodoroScreenFound {
                self.timedPomodoroWorker?.handleEnterForeground {
                    self.dismissPomodoroScreen()
                }
            }
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("ACTIVE")
        delayedEnterForegroundAction?()
        delayedEnterForegroundAction = nil
    }
    
    // MARK: - Private methods
    
    private func performIfPomodoroScreenFound(_ action: @escaping () -> Void) {
        let pomodoroScren = screens.pomodoroScreen()
        
        navigator?.navigate(
            to: { route in
                route
                    .top(.container(of: pomodoroScren))
            },
            completion: { result in
                switch result {
                case .success:
                    action()
                case .failure:
                    break
                }
            }
        )
    }
    
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

