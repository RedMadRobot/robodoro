//
//  SettingsView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 12.12.2022.
//

import SwiftUI

struct SettingsView: View {
    
    // MARK: - Private Properties
    
    @StateObject
    private var viewModel = SettingsViewModel()
    
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
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    navigator.pop()
                } label: {
                    Image(uiImage: Images.arrowLeft)
                }
            }
            ToolbarItem(placement: .principal) {
                Text("SETTINGS")
                    .font(.screeenTitle)
            }
        }
    }
    
    // MARK: - Private Properties
    
    @ViewBuilder
    private var frontView: some View {
        VStack(spacing: 24) {
            Toggle("Alarm sound", isOn: $viewModel.soundEnabled)
                .toggleStyle(SettingsToggleStyle())
            Toggle("Haptic", isOn: $viewModel.hapticEnabled)
                .toggleStyle(SettingsToggleStyle())
            Spacer()
        }
        .padding(.top, 30)
        .padding(.horizontal, 20)
    }
}

// MARK: - PreviewProvider

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(navigator: MainNavigator())
    }
}
