//
//  PreviousResultsView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 17.01.2023.
//

import Nivelir
import SwiftUI

struct PreviousResultsView: View {
    
    // MARK: - Private Properties
    
    @ObservedObject
    private var viewModel: PreviousResultsViewModel
    
    // MARK: - Init
    
    init(viewModel: PreviousResultsViewModel) {
        self.viewModel = viewModel
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
                warningView
                SpendedMinutesView(
                    dailyAverageFocusValue: viewModel.dailyAverageFocusValue,
                    totalFocusValue: viewModel.totalFocusValue)
                .padding(.horizontal, 16)
                TasksListView(tasks: viewModel.taskItems)
                Spacer(minLength: 80)
            }
        }
    }
    
    @ViewBuilder
    private var frontView: some View {
        VStack {
            Spacer()
            Button(
                Strings.PreviousResults.buttonTitle,
                action: viewModel.confirmButtonTapped
            )
            .buttonStyle(PrimaryButtonStyle())
            .padding(16)
        }
    }
    
    @ViewBuilder
    private var warningView: some View {
        HStack(alignment: .top, spacing: 10) {
            Images.info.swiftUIImage
            Text(Strings.PreviousResults.info)
                .textStyle(.regularText)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .background(Colors.gray.swiftUIColor)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .padding(.horizontal, 16)
        .padding(.vertical, 32)
    }
}

// MARK: - PreviewProvider

struct PreviousResultsView_Previews: PreviewProvider {
    static var previews: some View {
        PreviousResultsView(
            viewModel: PreviousResultsViewModel(
                navigator: ScreenNavigator(window: UIWindow()),
                screens: Screens()
            )
        )
    }
}
