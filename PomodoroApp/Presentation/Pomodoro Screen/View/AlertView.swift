//
//  AlertView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 13.12.2022.
//

import SwiftUI

struct AlertView: View {
    
    // MARK: - Private Properties
    
    private var cancelAction: () -> Void
    private var endAction: () -> Void
    
    // MARK: - Init
    
    init(
        cancelAction: @escaping () -> Void,
        endAction: @escaping () -> Void
    ) {
        self.cancelAction = cancelAction
        self.endAction = endAction
    }
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            Color(Colors.black).opacity(0.6)
            alertBanner
        }
        .ignoresSafeArea()
    }
    
    // MARK: - Private Properties
    
    @ViewBuilder
    private var alertBanner: some View {
        VStack(spacing: 40) {
            Text("Do you want to end this task?")
                .font(.miniTitle)
                .padding(.top, 24)
            HStack(spacing: 12) {
                Button("CANCEL") {
                    cancelAction()
                }
                .buttonStyle(SecondaryButtonStyle())
                Button("END") {
                    endAction()
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
        AlertView(cancelAction: {}, endAction: {})
            .background(Color(Colors.focusRed))
    }
}
