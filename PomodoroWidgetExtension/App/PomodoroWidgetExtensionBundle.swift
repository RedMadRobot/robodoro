//
//  PomodoroWidgetExtensionBundle.swift
//  PomodoroWidgetExtension
//
//  Created by Петр Тартынских  on 16.11.2022.
//

import WidgetKit
import SwiftUI

@main
struct PomodoroWidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        PomodoroWidgetExtensionLiveActivity()
    }
}
