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
    
    // MARK: - Init
    
    init(
        maxStagesCount: Int,
        activeStagesCount: Int,
        lastStageState: StageElementViewState
    ) {
        self.maxStagesCount = maxStagesCount
        self.activeStagesCount = activeStagesCount
        self.lastStageState = lastStageState
    }
    
    // MARK: - View
    
    var body: some View {
        HStack(spacing: Constants.spacing) {
            ForEach(0..<maxStagesCount, id: \.self) { stage in
                switch stage {
                case 0..<activeStagesCount:
                    StageElementView(state: .filled)
                case activeStagesCount:
                    StageElementView(state: lastStageState)
                default:
                    StageElementView(state: .empty)
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
            lastStageState: .half)
    }
}
