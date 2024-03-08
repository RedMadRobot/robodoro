//
//  DeclarativeController.swift
//  PomodoroApp
//
//  Created by Петр Тартынских on 08.03.2024.
//

import Nivelir
import SwiftUI
import SnapKit

// TODO: - Узнать на проработке
class DeclarativeController<Content: View>: UIViewController, ScreenKeyedContainer {
    
    // MARK: - Private Properties

    private let hostingController: UIHostingController<Content>
    
    private let didAppear: (() -> Void)?
    private let willDisappear: (() -> Void)?
    private let willAppear: (() -> Void)?

    // MARK: - Public properties
    
    var sizingOptions: UIHostingControllerSizingOptions {
        get {
            hostingController.sizingOptions
        }
        set {
            hostingController.sizingOptions = newValue
        }
    }
    
    let screenKey: ScreenKey
    
    // MARK: - Init

    init(
        screenKey: ScreenKey,
        content: Content,
        willAppear: (() -> Void)? = nil,
        didAppear: (() -> Void)? = nil,
        willDisappear: (() -> Void)? = nil
    ) {
        self.screenKey = screenKey
        self.hostingController = UIHostingController(rootView: content)
        self.willAppear = willAppear
        self.didAppear = didAppear
        self.willDisappear = willDisappear
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        return nil
    }

    // MARK: - UIViewController

    override open func viewDidLoad() {
        super.viewDidLoad()
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)

        hostingController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        willAppear?()
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        didAppear?()
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        willDisappear?()
    }
    
    // MARK: - Public methods
    
    func changeBgColor(_ color: UIColor) {
        hostingController.view.backgroundColor = color
    }
}
