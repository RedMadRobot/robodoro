//
//  ContentView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 11.11.2022.
//

import SwiftUI

struct PomodoroView: View {
    
    // MARK: - Private Properties
    
    @StateObject
    private var viewModel = PomodoroViewModel()
    
    @ObservedObject
    private var navigator: MainNavigator
    
    // MARK: - Init
    
    init(navigator: MainNavigator) {
        self.navigator = navigator
    }
    
    // MARK: - View
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView(viewModel: viewModel)
                frontView
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text(viewModel.pomodoroState.title)
                        .font(.stageLabel)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAlert()
                    } label: {
                        Image(uiImage: Images.logout)
                    }
                }
            }
            .animation(.easeInOut, value: viewModel.pomodoroState)
        }
    }
    
    // MARK: - Private Properties
    
    @ViewBuilder
    private var frontView: some View {
        VStack(spacing: 16) {
            Spacer()
            timeSection
            StageView(
                maxStagesCount: viewModel.maxStagesCount,
                activeStagesCount: viewModel.activeStagesCount,
                lastStageState: viewModel.lastStageState,
                theme: .dark)
            Spacer()
            Button {
                if viewModel.timerState == .ended {
                    navigator.hidePomodoroModal()
                } else {
                    viewModel.mainButtonAction()
                }
            } label: {
                Image(uiImage: viewModel.buttonImage)
            }
        }
    }
    
    @ViewBuilder
    private var timeSection: some View {
        HStack(alignment: .center, spacing: 0) {
            Text(viewModel.minutes)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .font(.time)
                .foregroundColor(Color(uiColor: Colors.black))
            Text(":")
                .font(.time)
                .foregroundColor(Color(uiColor: Colors.black))
            Text(viewModel.seconds)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.time)
                .foregroundColor(Color(uiColor: Colors.black))
        }
    }
    
    // MARK: - Private Methods
    
    private func showAlert() {
        navigator.showAlert(
            title: "Do you want to end this task?",
            primaryButtonTitle: "END",
            secondaryButtonTitle: "CANCEL",
            primaryAction: { navigator.hidePomodoroModal() },
            commonCompletion: { navigator.hideAlert() })
    }
}

// MARK: - PreviewProvider

struct PomodoroView_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroView(navigator: MainNavigator())
    }
}
