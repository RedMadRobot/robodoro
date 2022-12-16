//
//  SetTaskView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 15.12.2022.
//

import SwiftUI

struct SetTaskView: View {
    
    // MARK: - Private Propeties
    
    @StateObject
    private var viewModel = SetTaskViewModel()
    
    @ObservedObject
    private var navigator: MainNavigator
    
    // MARK: - Init
    
    init(navigator: MainNavigator) {
        self.navigator = navigator
    }
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            Color(Colors.white)
            frontView
        }
    }
        
    // MARK: - Private Properties
    
    @ViewBuilder
    private var frontView: some View {
        VStack {
            Text("SET YOUR TASK")
                .font(.customTitle)
                .padding(.vertical, 32)
            parameters
        }
    }
    
    @ViewBuilder
    private var parameters: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    TimePickerView(
                        value: $viewModel.focusTimeValue,
                        title: PomodoroState.focus.miniTitle,
                        color: Colors.focusRed)
                    TimePickerView(
                        value: $viewModel.breakTimeValue,
                        title: PomodoroState.break.miniTitle,
                        color: Colors.breakPurple)
                    TimePickerView(
                        value: $viewModel.longBreakTimeValue,
                        title: PomodoroState.longBreak.miniTitle,
                        color: Colors.longBreakGreen)
                    SessionStepperView(value: $viewModel.stagesCount)
                    TaskTitleFieldView(value: $viewModel.taskTitle)
                    Spacer()
                    Button("START TIMER") {
                        viewModel.applyParameters()
                        navigator.hideSetTaskSheet()
                        navigator.showPomodoroModal(delayed: true)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .padding(16)
                }
                .frame(minHeight: geometry.size.height)
            }
            .frame(width: geometry.size.width)
        }
    }
}

// MARK: - PreviewProvider

struct SetTaskView_Previews: PreviewProvider {
    static var previews: some View {
        SetTaskView(navigator: MainNavigator())
    }
}
