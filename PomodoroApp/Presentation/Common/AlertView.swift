//
//  AlertView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 13.12.2022.
//

import SwiftUI

struct AlertView: View {
    
    // MARK: - Private Properties
    
    private let title: String
    private let primaryButtonTitle: String
    private let secondaryButtonTitle: String
    
    private var primaryAction: () -> Void
    private var secondaryAction: () -> Void
    
    // MARK: - Init
    
    init(
        title: String,
        primaryButtonTitle: String,
        secondaryButtonTitle: String,
        primaryAction: @escaping () -> Void,
        secondaryAction: @escaping () -> Void
    ) {
        self.title = title
        self.primaryButtonTitle = primaryButtonTitle
        self.secondaryButtonTitle = secondaryButtonTitle
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            Color(Colors.black).opacity(0.6)
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
            Text(title)
                .font(.miniTitle)
                .padding(.top, 24)
            HStack(spacing: 12) {
                Button(secondaryButtonTitle) {
                    secondaryAction()
                }
                .buttonStyle(SecondaryButtonStyle())
                Button(primaryButtonTitle) {
                    primaryAction()
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity)
        .background(Color(Colors.white))
        .clipShape(RoundedRectangle(cornerRadius: 35))
        .padding(16)
    }
}

// MARK: - PreviewProvider

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView(
            title: "Do you want to end this task?",
            primaryButtonTitle: "CANCEL",
            secondaryButtonTitle: "END",
            primaryAction: {},
            secondaryAction: {})
        .background(Color(Colors.focusRed))
    }
}
