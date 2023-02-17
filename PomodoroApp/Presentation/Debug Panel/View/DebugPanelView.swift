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
                    Text("Debug panel")
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
                    placeholder: "Task title (optional)",
                    onShouldChangeText: viewModel.shouldChangeText)
                DatePicker(selection: $viewModel.taskDate, in: ...Date.now) {
                    Text("Task date")
                }
                VStack(alignment: .leading) {
                    Text("Completed interval")
                    TimeIntervalPicker(value: $viewModel.taskCompletedInterval)
                }
                Button("Create task") {
                    viewModel.createTask()
                }
                .foregroundColor(.blue)
            }
            Section {
                HStack {
                    Text("Total number of tasks:")
                    Spacer()
                    Text("\(viewModel.totalTasksCount)")
                }
                Button("Delete All tasks") {
                    viewModel.deleteAllTasks()
                }
                .foregroundColor(.red)
            }
            Section {
                Toggle("Shrink sliders step", isOn: $viewModel.shrinkSlidersStep)
                Button("Reset onboarding") {
                    viewModel.resetOnboarding()
                }
                .foregroundColor(.blue)
                Button("Reset last used values") {
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
