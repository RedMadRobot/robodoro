//
//  DebugPanelView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 16.02.2023.
//

import Nivelir
import SwiftUI

struct DebugPanelView: View {
    
    // MARK: - Private Properties
    
    @ObservedObject
    private var viewModel: DebugPanelViewModel
    
    // MARK: - Init
    
    init(viewModel: DebugPanelViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - View
    
    var body: some View {
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
            DebugPanelView(
                viewModel: DebugPanelViewModel(
                    navigator: ScreenNavigator(window: UIWindow()),
                    screens: Screens()
                )
            )
        }
    }
}
