//
//  AlertView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 13.12.2022.
//

import SwiftUI

struct AlertView: View {
    
    // MARK: - Private Properties
    
    @ObservedObject
    private var viewModel: AlertViewModel
    
    @ObservedObject
    private var navigator: MainNavigator
    
    // MARK: - Init
    
    init(navigator: MainNavigator) {
        self.navigator = navigator
        self.viewModel = navigator.alertViewModel
    }
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            Colors.black.swiftUIColor.opacity(0.6)
            alertBanner
        }
        .ignoresSafeArea()
        .transition(AnyTransition.opacity.animation(.linear(duration: 0.2)))
        .zIndex(1) // Без этого анимация не работает
    }
    
    // MARK: - Private Properties
    
    @ViewBuilder
    private var alertBanner: some View {
        VStack(spacing: 40) {
            Text(viewModel.title)
                .textStyle(.regularText)
                .padding(.top, 24)
            HStack(spacing: 12) {
                Button(viewModel.secondaryButtonTitle) {
                    viewModel.secondaryAction?()
                    viewModel.commonCompletion?()
                }
                .buttonStyle(SecondaryButtonStyle())
                Button(viewModel.primaryButtonTitle) {
                    viewModel.primaryAction?()
                    viewModel.commonCompletion?()
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity)
        .background(Colors.white.swiftUIColor)
        .clipShape(RoundedRectangle(cornerRadius: 35))
        .padding(16)
    }
}

// MARK: - PreviewProvider

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView(navigator: MainNavigator())
            .background(Colors.focusRed.swiftUIColor)
    }
}
