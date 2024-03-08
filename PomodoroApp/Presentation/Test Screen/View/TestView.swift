//
//  TestView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских on 07.03.2024.
//

import Nivelir
import SwiftUI

struct TestView: View {
    
    // MARK: - Private properties
    
    private var viewModel: TestViewModel
    
    // MARK: - Init
    
    init(viewModel: TestViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            Color.green
                .ignoresSafeArea()
            VStack {
                Text("Number of screen: \(viewModel.numberOfScreen)")
                Button(
                    "Present modally",
                    action: viewModel.presentModally
                )
                Button(
                    "Present bottom sheet",
                    action: viewModel.presentBottomSheet
                )
                Button(
                    "Push",
                    action: viewModel.push
                )
                Button(
                    "Close current",
                    action: viewModel.closeCurrent
                )
                Button(
                    "Close all",
                    action: viewModel.closeAll
                )
                Button(
                    "Show ROBODORO settings",
                    action: viewModel.showSettings
                )
            }
        }
        .border(.red, width: 5)
        .navigationTitle("Green screen")
    }
}
