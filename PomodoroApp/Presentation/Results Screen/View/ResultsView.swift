//
//  ResultsView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 12.12.2022.
//

import SwiftUI

struct ResultsView: View {
    
    // MARK: - Private Properties
    
    @ObservedObject
    private var viewModel: ResultsViewModel
    
    @ObservedObject
    private var navigator: MainNavigator
    
    // MARK: - Init
    
    init(
        viewModel: ResultsViewModel,
        navigator: MainNavigator
    ) {
        self.viewModel = viewModel
        self.navigator = navigator
    }
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            // TODO: - Показывать только если нет сохраненных задач
            NoTasksView()
            frontView
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("RESULTS PER WEEK")
                    .font(.customTitle)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    navigator.pushSettings()
                } label: {
                    Image(uiImage: Images.settings)
                }
            }
        }
    }
    
    // MARK: - Private Properties
    
    private var frontView: some View {
        VStack {
            Spacer()
            Button("LET’S GO") {
                // TODO: - Добавить экран с параметрами
                viewModel.prepareToStartPomodoro()
                navigator.showPomodoro()
            }
            .buttonStyle(BigBlackButtonStyle())
            .padding([.leading, .trailing], 16)
        }
    }
    
}

// MARK: - PreviewProvider

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView(
            viewModel: ResultsViewModel(),
            navigator: MainNavigator()
        )
    }
}