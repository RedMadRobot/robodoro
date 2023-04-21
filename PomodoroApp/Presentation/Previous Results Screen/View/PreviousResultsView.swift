//
//  PreviousResultsView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 17.01.2023.
//

import SwiftUI

struct PreviousResultsView: View {
    
    // MARK: - Private Properties
    
    @StateObject
    private var viewModel = PreviousResultsViewModel()
    
    @ObservedObject
    private var navigator: MainNavigator
    
    // MARK: - Init
    
    init(navigator: MainNavigator) {
        self.navigator = navigator
    }
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            tasksView
            frontView
        }
    }
    
    // MARK: - Private Properties
    
    @ViewBuilder
    private var tasksView: some View {
        ScrollView {
            VStack(spacing: 8) {
                Text("PREVIOUS RESULTS")
                    .font(.regularTitle)
                    .padding(.top, 32)
                warningView
                SpendedMinutesView(
                    dailyAverageFocusValue: viewModel.dailyAverageFocusValue,
                    totalFocusValue: viewModel.totalFocusValue)
                .padding(.horizontal, 16)
                TasksListView(tasks: viewModel.tasks)
                Spacer(minLength: 80)
            }
        }
    }
    
    @ViewBuilder
    private var frontView: some View {
        VStack {
            Spacer()
            Button("OKAY, I GOT IT") {
                viewModel.clearOldTasks()
                navigator.hidePreviousResultsSheet()
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(16)
        }
    }
    
    @ViewBuilder
    private var warningView: some View {
        HStack(alignment: .top, spacing: 10) {
            Images.info.suImage
            Text("Check out your results for the previous period. After clicking the button that data will be deleted.")
                .font(.regularText)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .background(Colors.gray.suColor)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .padding(.horizontal, 16)
        .padding(.vertical, 32)
    }
}

// MARK: - PreviewProvider

struct PreviousResultsView_Previews: PreviewProvider {
    static var previews: some View {
        PreviousResultsView(navigator: MainNavigator())
    }
}
