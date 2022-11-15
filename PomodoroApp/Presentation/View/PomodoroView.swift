//
//  ContentView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 11.11.2022.
//

import SwiftUI

struct PomodoroView: View {
    
    // MARK: - Private Properties
    
    @ObservedObject
    private var viewModel: PomodoroViewModel
    
    // MARK: - Init
    
    init() {
        viewModel = PomodoroViewModel()
    }
    
    // MARK: - View
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView(viewModel: viewModel)
                VStack(spacing: 16) {
                    Spacer()
                    Text(viewModel.showingTime)
                        .font(.time)
                    StageView(
                        stagesCount: viewModel.stagesCount,
                        filledCount: viewModel.filledCount)
                    Spacer()
                    // TODO: - Убрать вторую кнопку
                    HStack(spacing: 10) {
                        Button {
                            viewModel.pause()
                        } label: {
                            Image(uiImage: Images.pause)
                        }
                        Button {
                            viewModel.moveForward()
                        } label: {
                            Image(uiImage: Images.stop)
                        }
                    }
                }
            }
            .toolbar {
                if viewModel.showResetButton {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            viewModel.reset()
                        } label: {
                            Image(uiImage: Images.restart)
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Text(viewModel.pomodoroState.title)
                        .font(.stageLabel)
                }
            }
            // TODO: - Разобраться почему не работает
//            .animation(.easeInOut, value: viewModel.pomodoroState)
        }
    }
}

// MARK: - PreviewProvider

struct PomodoroView_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroView()
    }
}
