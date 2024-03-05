//
//  StageView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 15.11.2022.
//

import SwiftUI

struct StageView: View {
    
    // MARK: - Constants
    
    private enum Constants {
        static let spacing = CGFloat(6)
    }
    
    // MARK: - Private Properties
    
    private let maxStagesCount: Int
    private let activeStagesCount: Int
    private let lastStageState: StageElementViewState
    private var theme: ActivityViewTheme

    // MARK: - Init
    
    init(
        maxStagesCount: Int,
        activeStagesCount: Int,
        lastStageState: StageElementViewState,
        theme: ActivityViewTheme
    ) {
        self.maxStagesCount = maxStagesCount
        self.activeStagesCount = activeStagesCount
        self.lastStageState = lastStageState
        self.theme = theme
    }
    
    // MARK: - View
    
    var body: some View {
        HStack(spacing: Constants.spacing) {
            ForEach(0..<maxStagesCount, id: \.self) { stage in
                switch stage {
                case 0..<activeStagesCount:
                    StageElementView(state: .filled, theme: theme)
                case activeStagesCount:
                    StageElementView(state: lastStageState, theme: theme)
                default:
                    StageElementView(state: .empty, theme: theme)
                }
            }
        }
        .fixedSize()
    }
}

// MARK: - PreviewProvider

struct StageView_Previews: PreviewProvider {
    static var previews: some View {
        StageView(
            maxStagesCount: 8,
            activeStagesCount: 4,
            lastStageState: .half,
            theme: .dark
        )
    }
}
