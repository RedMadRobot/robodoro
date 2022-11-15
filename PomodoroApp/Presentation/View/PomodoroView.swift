//
//  ContentView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 11.11.2022.
//

import SwiftUI

struct PomodoroView: View {
    
    @ObservedObject
    private var viewModel: PomodoroViewModel
    
    init() {
        viewModel = PomodoroViewModel()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView(
                    pomodoroState: viewModel.pomodoroState,
                    timerState: viewModel.timerState)
                VStack(spacing: 16) {
                    Spacer()
                    Text("25:00")
                        .font(.time)
                    StageView(filledCount: 3)
                    Spacer()
                    Button {
                        viewModel.moveState()
                    } label: {
                        Image(uiImage: Images.pause)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        print("Restart")
                    } label: {
                        Image(uiImage: Images.restart)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Text(viewModel.pomodoroState.title)
                        .font(.stageLabel)
                }
            }
        }
    }
}

struct PomodoroView_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroView()
    }
}
