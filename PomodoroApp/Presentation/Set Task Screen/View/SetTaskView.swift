//
//  SetTaskView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 15.12.2022.
//

import SwiftUI

struct SetTaskView: View {
    
    // MARK: - Private Propeties
    
    @StateObject
    private var viewModel = SetTaskViewModel()
    
    @ObservedObject
    private var navigator: MainNavigator
    
    // MARK: - Init
    
    init(navigator: MainNavigator) {
        self.navigator = navigator
    }
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            Color(Colors.white)
            frontView
        }
    }
        
    // MARK: - Private Properties
    
    private var frontView: some View {
        VStack {
            Text("SET YOUR TASK")
                .font(.customTitle)
            Spacer()
            Button("START TIMER") {
                viewModel.applyParameters()
                navigator.hideSetTaskSheet()
                navigator.showPomodoroModal(delayed: true)
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.horizontal, 16)
        }
        .padding(.top, 32)
    }
}

// MARK: - PreviewProvider

struct SetTaskView_Previews: PreviewProvider {
    static var previews: some View {
        SetTaskView(navigator: MainNavigator())
    }
}
