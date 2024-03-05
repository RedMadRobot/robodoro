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
            Colors.white.swiftUIColor
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
            footer
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
                    Images.arrowLeft.swiftUIImage
                        .padding([.top, .bottom, .trailing], 10)
                }
                Spacer()
            }
            Text("SETTINGS")
                .textStyle(.regularTitle)
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
    
    @ViewBuilder
    private var footer: some View {
        HStack(spacing: 4) {
            Text("With")
                .textStyle(.regularText, color: Colors.textGray2.swiftUIColor)
            Images.heart.swiftUIImage
            Text("from red_mad_robot")
                .textStyle(.regularText, color: Colors.textGray2.swiftUIColor)
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
