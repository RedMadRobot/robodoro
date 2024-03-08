//
//  TestViewModel.swift
//  PomodoroApp
//
//  Created by Петр Тартынских on 07.03.2024.
//

import SwiftUI
import Nivelir

class TestViewModel: ViewModel {
    
    // MARK: - Private properties
    
    private let navigator: ScreenNavigator
    private let screens: Screens
    
    // MARK: - Public properties
    
    private(set) var numberOfScreen: Int
    
    private(set) var feedbackService: FeedbackService
    
    weak var viewController: UIViewController? {
        didSet {
            viewController?.view.backgroundColor = UIColor(Color.green)
        }
    }
    
    // MARK: - Init
    
    init(
        numberOfScreen: Int,
        navigator: ScreenNavigator,
        screens: Screens,
        feedbackService: FeedbackService = DI.services.feedbackService
    ) {
        self.numberOfScreen = numberOfScreen
        self.navigator = navigator
        self.screens = screens
        self.feedbackService = feedbackService
    }
    
    // MARK: - Public methods
    
    func presentModally() {
        navigator.navigate { route in
            route
                .top(.container)
                .present(
                    screens.testScreen(numberOfScreen: numberOfScreen + 1)
                        .withStackContainer()
                        .withModalPresentationStyle(.fullScreen)
                )
        }
    }
    
    func presentBottomSheet() {
        let bottomSheet = BottomSheet(
            detents: [.content, .large],
            preferredCard: BottomSheetCard(
                backgroundColor: UIColor(Color.green),
                contentInsets: UIEdgeInsets(
                    top: 20,
                    left: .zero,
                    bottom: .zero,
                    right: .zero
                )
            ),
            preferredGrabber: .default,
            prefferedGrabberForMaximumDetentValue: .default
        )
        
        navigator.navigate { route in
            route
                .top(.container)
                .present(
                    screens.testScreen(numberOfScreen: numberOfScreen + 1)
                        .withBottomSheetStack(bottomSheet)
                )
        }
    }
    
    func push() {
        navigator.navigate { route in
            route
                .top(.stack)
                .push(screens.testScreen(numberOfScreen: numberOfScreen + 1))
        }
    }
    
    func closeCurrent() {
        if viewController?.stack?.viewControllers.count ?? 1 > 1 {
            navigator.navigate { route in
                route
                    .top(.stack)
                    .pop()
            }
        } else {
            navigator.navigate(from: viewController?.presenting) { route in
                route
                    .dismiss()
            }
        }
    }
    
    func closeAll() {
        let firstScreen = screens.testScreen(numberOfScreen: 0)
        print(firstScreen.key)
        
        navigator.navigate { route in
            route
                .first(.container(key: firstScreen.key))
                .makeVisible()
        }
    }
}
