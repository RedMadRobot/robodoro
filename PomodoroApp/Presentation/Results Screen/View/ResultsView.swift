//
//  ResultsView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 12.12.2022.
//

import SwiftUI
import SwipeActions

struct ResultsView: View {
    
    // MARK: - Private Properties
    
    @StateObject
    private var viewModel = ResultsViewModel()
    
    @ObservedObject
    private var navigator: MainNavigator
    
    // MARK: - Init
    
    init(navigator: MainNavigator) {
        self.navigator = navigator
    }
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            backView
            frontView
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("RESULTS PER WEEK")
                    .font(.customTitle)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.resetSwipeState()
                    navigator.pushSettings()
                } label: {
                    Image(uiImage: Images.settings)
                }
            }
        }
    }
    
    // MARK: - Private Properties
    
    @ViewBuilder
    private var backView: some View {
        if viewModel.tasks.isEmpty {
            NoTasksView()
        } else {
            tasksView
        }
    }
    
    @ViewBuilder
    private var tasksView: some View {
        ZStack {
            Color(Colors.defaultGray)
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 8) {
                    SpendedMinutesView(
                        dailyAverageFocusValue: viewModel.dailyAverageFocusValue,
                        totalFocusValue: viewModel.totalFocusValue)
                    .padding(.horizontal, 16)
                    .padding(.top, 30)
                    TasksListView(
                        swipeState: $viewModel.swipeState,
                        tasks: viewModel.tasks,
                        onDelete: { task in
                            showAlert(taskToDelete: task)
                        })
                    Spacer(minLength: 80)
                }
            }
        }
    }
    
    @ViewBuilder
    private var frontView: some View {
        VStack {
            Spacer()
            Button("LET’S GO") {
                viewModel.resetSwipeState()
                navigator.showSetTaskSheet()
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(16)
        }
    }
    
    // MARK: - Private Methods
    
    private func showAlert(taskToDelete: PomodoroTask) {
        viewModel.prepareToDeleteTask(task: taskToDelete)
        navigator.showAlert(
            title: "Do you want to delete this task?",
            primaryButtonTitle: "DELETE",
            secondaryButtonTitle: "CANCEL",
            primaryAction: { viewModel.deleteSelectedTask() },
            secondaryAction: { viewModel.resetSwipeState() },
            commonCompletion: { navigator.hideAlert() })
    }
}

// MARK: - PreviewProvider

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView(navigator: MainNavigator())
    }
}
