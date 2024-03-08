//
//  TestView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских on 07.03.2024.
//

import SwiftUI
import Nivelir

struct TestView: View, ScreenKeyedContainer {
    
    // MARK: - Private properties
    
    private var viewModel: TestViewModel
    
    // MARK: - Public properties
    
    var screenKey: ScreenKey
    
    // MARK: - Init
    
    init(
        screenKey: ScreenKey,
        viewModel: TestViewModel
    ) {
        self.screenKey = screenKey
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
            }
        }
        .border(.red, width: 5)
    }
}
