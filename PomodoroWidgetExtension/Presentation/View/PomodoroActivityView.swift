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
                    Text("\(state.leftTime)")
                        .font(.time)
                        .foregroundColor(Color(uiColor: Colors.element))
                    Spacer()
                    Link(destination: LinkManager.buttonActionURL) {
                        Image(uiImage: state.timerState.smallButtonImage)
                    }
                }
                HStack {
                    VStack(alignment: .leading, spacing: Constants.stageViewSpacing) {
                        StageView(
                            stagesCount: attribute.stagesCount,
                            filledCount: state.filledCount)
                        Text(state.pomodoroState.title)
                            .font(.stageLabel)
                            .foregroundColor(Color(uiColor: Colors.element))
                    }
                    Spacer()
                }
            }
            .padding(Constants.sidePadding)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}
