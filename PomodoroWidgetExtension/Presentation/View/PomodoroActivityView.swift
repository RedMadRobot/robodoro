//
//  PomodoroActivityView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 16.11.2022.
//

import WidgetKit
import SwiftUI

struct PomodoroActivityView: View {
    
    // MARK: - Constants
    
    private enum Constants {
        static let timeSpacing = CGFloat(35)
        static let stageViewSpacing = CGFloat(8)
        static let sidePadding = CGFloat(16)
    }
    
    // MARK: - Private Properties
    
    private let attribute: LiveActivityAttributes
    private let state: LiveActivityAttributes.ContentState
    private let dateComponentsFormatter: DateComponentsFormatter = .minutesAndSecondsFormatter
    
    // MARK: - Init
    
    init(
        attribute: LiveActivityAttributes,
        state: LiveActivityAttributes.ContentState
    ) {
        self.attribute = attribute
        self.state = state
    }
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            BackgroundView(state: state)
            VStack(alignment: .center, spacing: Constants.timeSpacing) {
                HStack {
                    Group {
                        switch state.timerState {
                        case .ended:
                            Text(dateComponentsFormatter.getFormattedTime(time: 0))
                        case .initial(let pausedTime), .paused(let pausedTime):
                            Text(dateComponentsFormatter.getFormattedTime(time: pausedTime))
                        case .running:
                            Text(timerInterval: Date.now...state.stageEndDate)
                        }
                    }
                    .font(.time)
                    .foregroundColor(Color(uiColor: Colors.black))
                    
                    Spacer()
                    Link(destination: LinkManager.buttonActionURL(action: state.actionLink)) {
                        Image(uiImage: state.buttonImage)
                    }
                }
                HStack {
                    VStack(alignment: .leading, spacing: Constants.stageViewSpacing) {
                        StageView(
                            maxStagesCount: attribute.maxStagesCount,
                            activeStagesCount: state.activeStagesCount,
                            lastStageState: state.lastStageState)
                        Text(state.pomodoroState.title)
                            .font(.stageLabel)
                            .foregroundColor(Color(uiColor: Colors.black))
                    }
                    Spacer()
                }
            }
            .padding(Constants.sidePadding)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}
