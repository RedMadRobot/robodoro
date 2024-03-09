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
    
    // MARK: - Private properties
    
    private let onViewDidLoad: () -> Void
    private let onViewDidAppear: () -> Void
    
    // MARK: - Public properties
    
    private(set) var screenKey: ScreenKey
    
    // MARK: - Init
    
    init(
        screenKey: ScreenKey,
        rootView: Content,
        onViewDidLoad: @escaping () -> Void = {},
        onViewDidAppear: @escaping () -> Void = {}
    ) {
        self.screenKey = screenKey
        self.onViewDidLoad = onViewDidLoad
        self.onViewDidAppear = onViewDidAppear
        super.init(rootView: rootView)
    }
    
    @MainActor
    required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sizingOptions = .preferredContentSize
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        onViewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        onViewDidAppear()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.invalidateIntrinsicContentSize()
    }
}
