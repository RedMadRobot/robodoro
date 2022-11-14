//
//  ContentView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 11.11.2022.
//

import SwiftUI

struct PomodoroView: View {
    
    @ObservedObject
    private var viewModel: PomodoroViewModel
    
    init() {
        viewModel = PomodoroViewModel()
    }
    
    var body: some View {
        ZStack {
            BackgroundView(
                pomodoroState: viewModel.pomodoroState,
                timerState: viewModel.timerState)
            Text("POMODORO")
        }
    }
}

struct PomodoroView_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroView()
    }
}
