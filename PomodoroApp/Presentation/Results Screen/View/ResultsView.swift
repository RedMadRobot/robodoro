//
//  ResultsView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 12.12.2022.
//

import SwiftUI

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
                    .font(.regularTitle)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    navigator.pushSettings()
                } label: {
                    Images.settings.suImage
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
            Colors.defaultGray.suColor
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 8) {
                    SpendedMinutesView(
                        dailyAverageFocusValue: viewModel.dailyAverageFocusValue,
                        totalFocusValue: viewModel.totalFocusValue)
                    .padding(.horizontal, 16)
                    .padding(.top, 30)
                    TasksListView(
                        tasks: viewModel.tasks,
                        disableAnimations: !navigator.rootIsVisible,
                        onDelete: { task in
                            showAlert(taskToDelete: task)
                        })
                    deletionOnboarding
                    Spacer(minLength: 80)
                }
            }
        }
    }
    
    @ViewBuilder
    private var deletionOnboarding: some View {
        if viewModel.showDeletionOnboarding {
            Text("If you want to delete the task, you need to tap on the cell and confirm the action")
                .font(.regularText)
                .foregroundColor(Colors.textGray1.suColor)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 50)
                .padding(.vertical, 16)
                .animation(.easeInOut, value: viewModel.showDeletionOnboarding)
        }
    }
    
    @ViewBuilder
    private var frontView: some View {
        VStack {
            Spacer()
            Button("LET’S GO") {
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
            commonCompletion: { navigator.hideAlert() })
    }
}

// MARK: - PreviewProvider

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ResultsView(navigator: MainNavigator())
        }
    }
}
