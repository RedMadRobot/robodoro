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
    
    init(viewModel: PomodoroViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - View
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView(viewModel: viewModel)
                VStack(spacing: 16) {
                    Spacer()
                    Text(viewModel.formattedTime)
                        .font(.time)
                        .foregroundColor(Color(uiColor: Colors.element))
                        //.animation(.easeInOut, value: viewModel.leftTime)
                    StageView(
                        stagesCount: viewModel.stagesCount,
                        filledCount: viewModel.filledCount)
                    Spacer()
                    Button {
                        viewModel.mainButtonAction()
                    } label: {
                        Image(uiImage: viewModel.buttonImage)
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
                        .foregroundColor(Color(uiColor: Colors.element))
                }
            }
            // TODO: - Разобраться почему не работает
            //.animation(.easeInOut, value: viewModel.pomodoroState)
        }
    }
}

// MARK: - PreviewProvider

struct PomodoroView_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroView(viewModel: PomodoroViewModel())
    }
}
