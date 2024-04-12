//
//  CustomNavigationController.swift
//  PomodoroApp
//
//  Created by Петр Тартынских on 08.03.2024.
//

import Nivelir
import UIKit

protocol CustomStackControllerCommonBehavior: UINavigationController {
    func setupAppearance()
}

extension CustomStackControllerCommonBehavior {
    func setupAppearance() {
        let tintColor = Colors.black.color
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        let titleTextAttributes = [
            NSAttributedString.Key.font: TextStyle.regularTitle.uiFont,
            NSAttributedString.Key.foregroundColor: tintColor
        ]
        appearance.titleTextAttributes = titleTextAttributes
        
        let backButtonImage = Images.arrowLeft.image
        appearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        
        let standardAppearance = appearance.copy()
        standardAppearance.configureWithDefaultBackground()
        
        navigationBar.tintColor = tintColor
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.standardAppearance = standardAppearance
        navigationBar.compactAppearance = appearance
        navigationBar.compactScrollEdgeAppearance = appearance
    }
}

// MARK: - CustomStackController

final class CustomStackController: UINavigationController, CustomStackControllerCommonBehavior {
    
    // MARK: - Public properties
    
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
    }
}

// MARK: - CustomBottomSheetStackController

final class CustomBottomSheetStackController: BottomSheetStackController, CustomStackControllerCommonBehavior {
    
    // MARK: - Public properties
    
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
    }
}
