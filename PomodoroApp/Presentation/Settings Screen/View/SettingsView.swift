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
            ToolbarItem(placement: .principal) {
                navBarView
            }
        }
    }
    
    // MARK: - Private Properties
    
    @ViewBuilder
    private var frontView: some View {
        VStack(spacing: 4) {
            Toggle("Alarm sound", isOn: $viewModel.soundEnabled)
                .toggleStyle(SettingsToggleStyle())
            Toggle("Haptic", isOn: $viewModel.hapticEnabled)
                .toggleStyle(SettingsToggleStyle())
            Spacer()
        }
        .padding(.top, 20)
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 10))
    }
    
    @ViewBuilder
    private var navBarView: some View {
        ZStack {
            HStack {
                Button {
                    navigator.pop()
                } label: {
                    Image(uiImage: Images.arrowLeft)
                        .padding([.top, .bottom, .trailing], 10)
                }
                Spacer()
            }
            Text("SETTINGS")
                .font(.regularTitle)
        }
    }
}

// MARK: - PreviewProvider

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView(navigator: MainNavigator())
        }
    }
}
