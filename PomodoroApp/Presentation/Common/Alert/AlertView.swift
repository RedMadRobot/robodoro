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
    
    // MARK: - Init
    
    init(viewModel: AlertViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            Colors.black.swiftUIColor.opacity(0.6)
            alertBanner
        }
        .ignoresSafeArea()
        .transition(AnyTransition.opacity.animation(.linear(duration: 0.2)))
    }
    
    // MARK: - Private Properties
    
    @ViewBuilder
    private var alertBanner: some View {
        VStack(spacing: 40) {
            Text(viewModel.title)
                .textStyle(.regularText)
                .padding(.top, 24)
            HStack(spacing: 12) {
                Button(
                    viewModel.secondaryButtonTitle,
                    action: viewModel.secondaryButtonTapped
                )
                .buttonStyle(SecondaryButtonStyle())
                Button(
                    viewModel.primaryButtonTitle,
                    action: viewModel.primaryButtonTapped
                )
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
        AlertView(
            viewModel: AlertViewModel(
                title: "Alert",
                primaryButtonTitle: "OK",
                secondaryButtonTitle: "Cancel",
                primaryAction: {},
                secondaryAction: {},
                commonCompletion: {}
            )
        )
        .background(Colors.focusRed.swiftUIColor)
    }
}
