//
//  UIHostingController+ScreenKeyedContainer.swift
//  PomodoroApp
//
//  Created by Петр Тартынских on 08.03.2024.
//

import Nivelir
import SwiftUI

extension UIHostingController: ScreenKeyedContainer {
    public var screenKey: ScreenKey {
        guard let rootKeyedView = rootView as? ScreenKeyedContainer else { return ScreenKey(name: "", traits: []) }
        return rootKeyedView.screenKey
    }
}
