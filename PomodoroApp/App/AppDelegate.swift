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
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let navigator = ScreenNavigator(window: window)
        
        self.window = window
        self.navigator = navigator
        
        navigator
            .navigate(to: screens.showTestRoute())
        
        return true
    }
    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        guard let action = LinkManager.manage(url: url) else { return false }
//
//        
//        return true
//    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("BACKGROUND")
        
//        performIfPomodoroScreenFound {
//            let timedPomodoroWorker = DI.workers.timedPomodoroWorker
//            timedPomodoroWorker.handleEnterBackground()
//        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("FOREGROUND")
        
//        performIfPomodoroScreenFound {
//            let timedPomodoroWorker = DI.workers.timedPomodoroWorker
//            timedPomodoroWorker.handleEnterForeground()
//        }
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
}

