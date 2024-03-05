//
//  BackgroundView.swift
//  PomodoroWidgetExtensionExtension
//
//  Created by Петр Тартынских  on 17.11.2022.
//

import SwiftUI

struct BackgroundView: View {
    
    // MARK: - Private Properties
    
    private let state: LiveActivityAttributes.ContentState

    // MARK: - Init
    
    init(state: LiveActivityAttributes.ContentState) {
        self.state = state
    }
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            switch state.pomodoroState {
            case .focus:
                FocusedBackground(
                    backgroundColor: state.backgroundColor,
                    strokeColor: state.strokeColor
                )
            case .break:
                BreakBackground(
                    backgroundColor: state.backgroundColor,
                    strokeColor: state.strokeColor
                )
            case .longBreak:
                LongBreakBackground(
                    backgroundColor: state.backgroundColor,
                    strokeColor: state.strokeColor
                )
            }
        }
    }
}
