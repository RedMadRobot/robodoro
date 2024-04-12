//
//  ContentView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 11.11.2022.
//

import Nivelir
import SwiftUI

struct PomodoroView: View {
    
    // MARK: - Private Properties
    
    @ObservedObject
    private var viewModel: PomodoroViewModel
    
    // MARK: - Init
    
    init(viewModel: PomodoroViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            BackgroundView(viewModel: viewModel)
            frontView
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text(viewModel.pomodoroState.title)
                    .textStyle(.stageLabel)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: viewModel.endTaskTapped) {
                    Images.logout.swiftUIImage
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
        .animation(.easeInOut, value: viewModel.pomodoroState)
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
                    viewModel.hideScreen()
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
}

// MARK: - PreviewProvider

struct PomodoroView_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroView(
            viewModel: PomodoroViewModel(
                navigator: ScreenNavigator(window: UIWindow()),
                screens: Screens()
            )
        )
    }
}
