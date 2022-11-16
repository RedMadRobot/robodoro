//
//  PomodoroApp.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 11.11.2022.
//

import SwiftUI

@main
struct PomodoroApp: App {
    
    @StateObject
    private var pomodoroViewModel = PomodoroViewModel()
    
    var body: some Scene {
        WindowGroup {
            PomodoroView(viewModel: pomodoroViewModel)
        }
    }
}
