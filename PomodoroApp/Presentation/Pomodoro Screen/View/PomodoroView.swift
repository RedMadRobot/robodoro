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
                        .textStyle(.stageLabel)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAlert()
                    } label: {
                        Images.logout.swiftUIImage
                            .padding([.top, .bottom, .leading], 10)
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
                viewModel.buttonImage
                    .padding(.all, 10)
            }
        }
    }
    
    @ViewBuilder
    private var timeSection: some View {
        HStack(alignment: .center, spacing: 0) {
            Text(viewModel.minutes)
                .textStyle(.time, color: Colors.black.swiftUIColor)
                .frame(maxWidth: .infinity, alignment: .trailing)
            Text(":")
                .textStyle(.time, color: Colors.black.swiftUIColor)
            Text(viewModel.seconds)
                .textStyle(.time, color: Colors.black.swiftUIColor)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    // MARK: - Private Methods
    
    private func showAlert() {
        navigator.showAlert(
            title: Strings.PomodoroScreen.EndTaskAlert.title,
            primaryButtonTitle: Strings.PomodoroScreen.EndTaskAlert.primaryAction,
            secondaryButtonTitle: Strings.PomodoroScreen.EndTaskAlert.secondaryAction,
            primaryAction: {
                viewModel.resetWorker()
                navigator.hidePomodoroModal()
            },
            commonCompletion: { navigator.hideAlert() })
    }
}

// MARK: - PreviewProvider

struct PomodoroView_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroView(navigator: MainNavigator())
    }
}
