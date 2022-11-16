//
//  PomodoroActivityView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 16.11.2022.
//

import WidgetKit
import SwiftUI

struct PomodoroActivityView: View {
    
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
            Color(uiColor: state.pomodoroState.backgroundColor)
            VStack(alignment: .center) {
                Text("\(attribute.stagesCount)")
                Text("\(state.filledCount)")
                Text("\(state.leftTime)")
                Text(String(describing: state.pomodoroState))
                Text(String(describing: state.timerState))
                // TODO: - Перенести маленькие иконки в ассеты виджета
                Image(uiImage: state.timerState.smallButtonImage)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}
