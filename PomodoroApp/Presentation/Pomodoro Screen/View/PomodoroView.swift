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
    
    @ObservedObject
    private var navigator: MainNavigator
    
    // MARK: - Init
    
    init(
        viewModel: PomodoroViewModel,
        navigator: MainNavigator
    ) {
        self.viewModel = viewModel
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
                        // TODO: - Добавить попап
                        navigator.hidePomodoro()
                    } label: {
                        Image(uiImage: Images.logout)
                    }
                }
            }
            .animation(.easeInOut, value: viewModel.pomodoroState)
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
}

// MARK: - PreviewProvider

struct PomodoroView_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroView(
            viewModel: PomodoroViewModel(),
            navigator: MainNavigator()
        )
    }
}
