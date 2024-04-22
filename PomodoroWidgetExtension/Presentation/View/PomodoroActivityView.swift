//
//  PomodoroActivityView.swift
//  PomodoroWidgetExtension
//
//  Created by Петр Тартынских  on 16.11.2022.
//

import WidgetKit
import SwiftUI

// MARK: - Constants

private enum Constants {
    static let timeSpacing = CGFloat(35)
    static let timeSpacingSmall = CGFloat(10)
    static let stageViewSpacing = CGFloat(8)
    static let sidePadding = CGFloat(16)
    static let sidePaddingSmall = CGFloat(0)
}

enum ActivityViewSize {
    case small, large
}

extension ActivityViewSize {
    var timeSpacing: CGFloat {
        switch self {
        case .small:
            return Constants.timeSpacingSmall
        case .large:
            return Constants.timeSpacing
        }
    }
    
    var textStyle: TextStyle {
        switch self {
        case .small:
            return .widgetSmallTime
        case .large:
            return .widgetBigTime
        }
    }
    
    var sidePadding: CGFloat {
        switch self {
        case .small:
            return Constants.sidePaddingSmall
        case .large:
            return Constants.sidePadding
        }
    }
}

struct PomodoroActivityFullView: View {
    
    // MARK: - Private Properties
    
    private let theme: ActivityViewTheme
    private let size: ActivityViewSize
    private let attribute: LiveActivityAttributes
    private let state: LiveActivityAttributes.ContentState
    
    // MARK: - Init
    
    init(
        attribute: LiveActivityAttributes,
        state: LiveActivityAttributes.ContentState,
        theme: ActivityViewTheme,
        size: ActivityViewSize
    ) {
        self.attribute = attribute
        self.state = state
        self.theme = theme
        self.size = size
    }
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            BackgroundView(state: state)
            PomodoroActivityView(attribute: attribute, state: state, theme: theme, size: size)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct PomodoroActivityView: View {
    
    // MARK: - Private Properties
    
    private let theme: ActivityViewTheme
    private let size: ActivityViewSize
    private let attribute: LiveActivityAttributes
    private let state: LiveActivityAttributes.ContentState
    
    // MARK: - Init
    
    init(
        attribute: LiveActivityAttributes,
        state: LiveActivityAttributes.ContentState,
        theme: ActivityViewTheme,
        size: ActivityViewSize
    ) {
        self.attribute = attribute
        self.state = state
        self.theme = theme
        self.size = size
    }
    
    // MARK: - View
    
    var body: some View {
        VStack(alignment: .center, spacing: size.timeSpacing) {
            HStack {
                Text(state: state)
                    .textStyle(
                        size.textStyle,
                        color: theme == .dark ? theme.mainColor : state.strokeColor
                    )
                Spacer()
                Link(destination: LinkManager.buttonActionURL(action: state.actionLink)) {
                    state.buttonImage
                        .renderingMode(.template)
                        .foregroundColor(theme.mainColor)
                        .padding(.all, 10)
                }
            }
            HStack {
                VStack(alignment: .leading, spacing: Constants.stageViewSpacing) {
                    StageView(
                        maxStagesCount: attribute.maxStagesCount,
                        activeStagesCount: state.activeStagesCount,
                        lastStageState: state.lastStageState,
                        theme: theme
                    )
                    Text(state.pomodoroState.title)
                        .textStyle(.stageLabel, color: theme.mainColor)
                }
                Spacer()
            }
            if size == .small {
                Spacer()
            }
        }
        .padding(size.sidePadding)
    }
}
