//
//  AppDelegate.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 22.01.2024.
//

import UIKit
import Navidux

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let navigation = NavigationControllerImpl { controller in
            controller.navigationBar.isTranslucent = true
        }
        
        let screenFactory = NaviduxScreenFactory()
        let alertFactory = AlertFactoryImpl()
        let navigationCoordinatorProxy = NavigationCoordinatorProxy()
        let screenAssembler = NaviduxScreenAssembler(
            screenFactory: screenFactory,
            alertFactory: alertFactory,
            screenCoordinator: navigationCoordinatorProxy
        )
        let navigationCoordinator = NavigationCoordinator(
            navigation,
            screenAssembler: screenAssembler
        )
        navigationCoordinatorProxy.subject = navigationCoordinator
        navigationCoordinatorProxy.route(
            with: .push(
                .testScreen,
                ScreenConfig(navigationTitle: "Test screen", isNeedSetBackButton: false),
                .fullscreen
            )
        )
        
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
        
        return true
    }
}

