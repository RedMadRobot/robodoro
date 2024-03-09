//
//  ResultsView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 12.12.2022.
//

import Nivelir
import SwiftUI

struct ResultsView: View {
    
    // MARK: - Private Properties
    
    @ObservedObject
    private var viewModel: ResultsViewModel
    
    // MARK: - Init
    
    init(viewModel: ResultsViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            backView
            frontView
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: viewModel.moveToSettingsTapped) {
                    Images.settings.swiftUIImage
                }
            }
        }
        .overlay(
            ZStack {
                switch viewModel.alertState {
                case .noAlert:
                    EmptyView()
                case .presenting(let viewModel):
                    AlertView(viewModel: viewModel)
                }
            }
        )
    }
    
    // MARK: - Private Properties
    
    @ViewBuilder
    private var backView: some View {
        if viewModel.taskItems.isEmpty {
            NoTasksView()
        } else {
            tasksView
        }
    }
    
    @ViewBuilder
    private var tasksView: some View {
        ZStack {
            Colors.defaultGray.swiftUIColor
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 8) {
                    SpendedMinutesView(
                        dailyAverageFocusValue: viewModel.dailyAverageFocusValue,
                        totalFocusValue: viewModel.totalFocusValue)
                    .padding(.horizontal, 16)
                    .padding(.top, 30)
                    TasksListView(
                        tasks: viewModel.taskItems,
                        onDelete: { task in
                            viewModel.prepareToDeleteTask(task: task)
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
            Text(Strings.ResultsScreen.info)
                .textStyle(.regularText, color: Colors.textGray1.swiftUIColor)
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
            Button(
                Strings.ResultsScreen.setTaskAction,
                action: viewModel.setTaskTapped
            )
            .buttonStyle(PrimaryButtonStyle())
            .padding(16)
        }
    }
}

// MARK: - PreviewProvider

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ResultsView(
                viewModel: ResultsViewModel(
                    navigator: ScreenNavigator(window: UIWindow()),
                    screens: Screens()
                )
            )
        }
    }
}
