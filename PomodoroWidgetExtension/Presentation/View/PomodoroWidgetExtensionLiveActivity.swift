//
//  PomodoroWidgetExtensionLiveActivity.swift
//  PomodoroWidgetExtension
//
//  Created by Петр Тартынских  on 16.11.2022.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct PomodoroWidgetExtensionLiveActivity: Widget {

    // MARK: - Constants

    private enum Constants {
        static let textWidth = CGFloat(60)
        static let imageSize = CGFloat(20)
        static let padding = CGFloat(12)
    }
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivityAttributes.self) { context in
            PomodoroActivityFullView(
                attribute: context.attributes,
                state: context.state,
                theme: .dark,
                size: .large)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.bottom) {
                    PomodoroActivityView(
                        attribute: context.attributes,
                        state: context.state,
                        theme: .light,
                        size: .small)
                }
            } compactLeading: {
                Text(state: context.state)
                    .frame(width: Constants.textWidth)
                    .font(.stageLabel)
                    .padding([.leading], Constants.padding)
                    .foregroundColor(Color(context.state.strokeColor))
            } compactTrailing: {
                Image(uiImage: context.state.islandImage)
                    .resizable()
                    .frame(width: Constants.imageSize, height: Constants.imageSize)
                    .padding([.trailing], Constants.padding)
            } minimal: {}
        }
    }
}
