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
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let navigator = ScreenNavigator(window: window)
        let screens = Screens()
        
        self.window = window
        self.navigator = navigator
        
        navigator
            .navigate(to: screens.showTestRoute())
        
        return true
    }
}

