//
//  SetTaskView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 15.12.2022.
//

import Combine
import Nivelir
import SwiftUI

struct SetTaskView: View {
    
    // MARK: - Private Propeties
    
    @ObservedObject
    private var viewModel: SetTaskViewModel
    
    // MARK: - Init
    
    init(viewModel: SetTaskViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            Colors.white.swiftUIColor
                .ignoresSafeArea()
            frontView
        }
    }
        
    // MARK: - Private Properties
    
    @ViewBuilder
    private var frontView: some View {
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                ScrollView {
                    VStack {
                        TimePickerView(
                            value: $viewModel.focusTimeValue,
                            title: PomodoroState.focus.miniTitle,
                            color: Colors.focusRed.swiftUIColor,
                            shrinked: viewModel.shrinkSlidersStep
                        )
                        TimePickerView(
                            value: $viewModel.breakTimeValue,
                            title: PomodoroState.break.miniTitle,
                            color: Colors.breakPurple.swiftUIColor,
                            shrinked: viewModel.shrinkSlidersStep
                        )
                        TimePickerView(
                            value: $viewModel.longBreakTimeValue,
                            title: PomodoroState.longBreak.miniTitle,
                            color: Colors.longBreakGreen.swiftUIColor,
                            shrinked: viewModel.shrinkSlidersStep
                        )
                        SessionStepperView(value: $viewModel.stagesCount)
                        taskTitleFieldView(proxy: proxy)
                        Spacer()
                        Button(
                            Strings.SetTask.startTimerAction,
                            action: viewModel.startTimerTapped
                        )
                        .buttonStyle(PrimaryButtonStyle())
                        .padding(16)
                    }
                    .frame(minHeight: geometry.size.height)
                }
                .frame(width: geometry.size.width)
            }
        }
    }
    
    // MARK: - Private Methods
    
    @ViewBuilder
    private func taskTitleFieldView(proxy: ScrollViewProxy) -> some View {
        TaskTitleFieldView(
            value: $viewModel.taskTitle,
            onShouldChangeText: viewModel.shouldChangeText
        )
        .id(1)
        .onReceive(keyboardPublisher) { value in
            if value {
                scrollToTextField(proxy: proxy)
            }
        }
        .background(
            GeometryReader { geometry in
                Color(.clear)
                    .onChange(of: geometry.size) { _ in
                        scrollToTextField(proxy: proxy)
                    }
            }
        )
    }
    
    // MARK: - Private Methods
    
    private func scrollToTextField(proxy: ScrollViewProxy) {
        withAnimation(.linear(duration: 0.1)) {
            proxy.scrollTo(1, anchor: .bottom)
        }
    }
}

// MARK: - PreviewProvider

struct SetTaskView_Previews: PreviewProvider {
    static var previews: some View {
        SetTaskView(
            viewModel: SetTaskViewModel(
                navigator: ScreenNavigator(window: UIWindow()),
                screens: Screens()
            )
        )
    }
}
