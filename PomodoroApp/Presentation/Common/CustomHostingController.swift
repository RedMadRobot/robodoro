//
//  CustomHostingController.swift
//  PomodoroApp
//
//  Created by Петр Тартынских on 08.03.2024.
//

import Nivelir
import SwiftUI

// MARK: - CustomHostingController

final class CustomHostingController<Content: View>: UIHostingController<Content>, ScreenKeyedContainer {
    
    // MARK: - Public properties
    
    private(set) var screenKey: ScreenKey
    
    // MARK: - Init
    
    init(
        screenKey: ScreenKey,
        rootView: Content
    ) {
        self.screenKey = screenKey
        super.init(rootView: rootView)
    }
    
    @MainActor
    required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
