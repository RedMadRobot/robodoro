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
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivityAttributes.self) { context in
            PomodoroActivityView(
                attribute: context.attributes,
                state: context.state)
        } dynamicIsland: { _ in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    // Без этого активити не отображается
                    Text("")
                }
            } compactLeading: {
                EmptyView()
            } compactTrailing: {
                EmptyView()
            } minimal: {
                EmptyView()
            }
        }
    }
}
