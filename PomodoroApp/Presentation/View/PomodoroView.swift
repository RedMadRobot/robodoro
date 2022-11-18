//
//  ContentView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 11.11.2022.
//

import SwiftUI

struct PomodoroView: View {
    
    // MARK: - Constants
    
    private enum Constants {
        
    }
    
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
                frontView
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
    
    // MARK: - Private Properties
    
    private var frontView: some View {
        VStack(spacing: 16) {
            Spacer()
            timeSection
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
    
    private var timeSection: some View {
        HStack(alignment: .center, spacing: 0) {
            Text(viewModel.minutes)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .font(.time)
                .foregroundColor(Color(uiColor: Colors.element))
//                .animation(.easeInOut, value: viewModel.leftTime)
            Text(":")
                .font(.time)
                .foregroundColor(Color(uiColor: Colors.element))
            Text(viewModel.seconds)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.time)
                .foregroundColor(Color(uiColor: Colors.element))
//                .animation(.easeInOut, value: viewModel.leftTime)
        }
    }
}

// MARK: - PreviewProvider

struct PomodoroView_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroView(viewModel: PomodoroViewModel())
    }
}
