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
    private var navigator: MainNavigator
    
    // MARK: - Init
    
    init(navigator: MainNavigator) {
        self.navigator = navigator
    }
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            Color(Colors.black).opacity(0.6)
            alertBanner
        }
    }
    
    // MARK: - Private Properties
    
    private var alertBanner: some View {
        VStack(spacing: 40) {
            Text("Do you want to end this task?")
                .font(.miniTitle)
                .padding(.top, 24)
            HStack(spacing: 12) {
                Button("CANCEL") {
                    // TODO: - Методы навигатора
                    print("Cancel")
                }
                .buttonStyle(SecondaryButtonStyle())
                Button("END") {
                    // TODO: - Методы навигатора
                    print("End")
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            .padding([.leading, .trailing], 16)
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
        ZStack {
            Color(Colors.focusRed)
            AlertView(navigator: MainNavigator())
        }
        .ignoresSafeArea()
    }
}
