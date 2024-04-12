//
//  BackgroundView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 14.11.2022.
//

import Nivelir
import SwiftUI

struct BackgroundView: View {
    
    // MARK: - Private Properties
    
    @ObservedObject
    private var viewModel: PomodoroViewModel
    
    // MARK: - Init
    
    init(viewModel: PomodoroViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            switch viewModel.pomodoroState {
            case .focus:
                FocusedBackground(
                    backgroundColor: viewModel.backgroundColor,
                    strokeColor: viewModel.strokeColor
                )
            case .break:
                BreakBackground(
                    backgroundColor: viewModel.backgroundColor,
                    strokeColor: viewModel.strokeColor
                )
            case .longBreak:
                LongBreakBackground(
                    backgroundColor: viewModel.backgroundColor,
                    strokeColor: viewModel.strokeColor
                )
            }
        }
        .animation(.easeInOut, value: viewModel.pomodoroState)
        .animation(.easeInOut, value: viewModel.timerState)
    }
}

// MARK: - PreviewProvider

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView(
            viewModel: PomodoroViewModel(
                navigator: ScreenNavigator(window: UIWindow()),
                screens: Screens()
            )
        )
    }
}
