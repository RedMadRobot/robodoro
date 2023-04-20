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
            Colors.white.suColor
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
            Text("With ❤️ by red_mad_robot")
                .font(.regularText)
                .foregroundColor(Colors.textGray2.suColor)
        }
        .padding(EdgeInsets(top: 20, leading: 10, bottom: 5, trailing: 10))
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
            #if DEBUG
            HStack {
                Spacer()
                Button {
                    navigator.pushDebugPanel()
                } label: {
                    Text("Debug panel")
                }
            }
            #endif
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
