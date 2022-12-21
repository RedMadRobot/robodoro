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
            if viewModel.showingAlert {
                alert
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("RESULTS PER WEEK")
                    .font(.customTitle)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
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
                        tasks: viewModel.tasks,
                        onDelete: { task in
                            viewModel.showAlert(taskToDelete: task)
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
                navigator.showSetTaskSheet()
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(16)
        }
    }
    
    @ViewBuilder
    private var alert: some View {
        AlertView(
            title: "Do you want to delete this task?",
            primaryButtonTitle: "DELETE",
            secondaryButtonTitle: "CANCEL",
            primaryAction: { viewModel.deleteSelectedTask() },
            secondaryAction: { viewModel.hideAlert() })
    }
}

// MARK: - PreviewProvider

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView(navigator: MainNavigator())
    }
}
