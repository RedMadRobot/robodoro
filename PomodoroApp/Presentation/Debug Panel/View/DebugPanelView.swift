//
//  DebugPanelView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 16.02.2023.
//

import SwiftUI

struct DebugPanelView: View {
    
    // MARK: - Private Properties
    
    @StateObject
    private var viewModel = DebugPanelViewModel()
    
    @ObservedObject
    private var navigator: MainNavigator
    
    // MARK: - Init
    
    init(navigator: MainNavigator) {
        self.navigator = navigator
    }
    
    // MARK: - View
    
    var body: some View {
        form
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(Strings.DebugPanel.navigationTitle)
                }
            }
    }
    
    // MARK: - Private Properties
    
    @ViewBuilder
    private var form: some View {
        Form {
            Section {
                CustomTextField(
                    text: $viewModel.taskTitle,
                    placeholder: Strings.DebugPanel.Form.name,
                    onShouldChangeText: viewModel.shouldChangeText)
                DatePicker(selection: $viewModel.taskDate, in: ...Date.now) {
                    Text(Strings.DebugPanel.Form.date)
                }
                VStack(alignment: .leading) {
                    Text(Strings.DebugPanel.Form.completedInterval)
                    TimeIntervalPicker(value: $viewModel.taskCompletedInterval)
                }
                Button(Strings.DebugPanel.Form.createTask) {
                    viewModel.createTask()
                }
                .foregroundColor(.blue)
            }
            Section {
                HStack {
                    Text(Strings.DebugPanel.Form.totalNumberOfTasks)
                    Spacer()
                    Text("\(viewModel.totalTasksCount)")
                }
                Button(Strings.DebugPanel.Form.deleteAllTasks) {
                    viewModel.deleteAllTasks()
                }
                .foregroundColor(.red)
            }
            Section {
                Toggle(
                    Strings.DebugPanel.Form.shrinkSlidersStep,
                    isOn: $viewModel.shrinkSlidersStep
                )
                Button(Strings.DebugPanel.Form.resetOnboarding) {
                    viewModel.resetOnboarding()
                }
                .foregroundColor(.blue)
                Button(Strings.DebugPanel.Form.resetLastUsedValues) {
                    viewModel.resetLastUsedValues()
                }
                .foregroundColor(.blue)
            }
        }
    }
}

// MARK: - PreviewProvider

struct DebagPanelView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DebugPanelView(navigator: MainNavigator())
        }
    }
}
