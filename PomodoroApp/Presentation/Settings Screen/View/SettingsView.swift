//
//  SettingsView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 12.12.2022.
//

import Nivelir
import SwiftUI

struct SettingsView: View {
    
    // MARK: - Private Properties
    
    @ObservedObject
    private var viewModel: SettingsViewModel
    
    // MARK: - Init
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            Colors.white.swiftUIColor
            frontView
        }
        .toolbar {
            #if DEBUG
            ToolbarItem(placement: .topBarTrailing) { moveToDebugPanelButton }
            #endif
        }
    }
    
    // MARK: - Private Properties
    
    @ViewBuilder
    private var frontView: some View {
        VStack(spacing: 4) {
            Toggle(
                Strings.Settings.alarmSound,
                isOn: $viewModel.soundEnabled
            )
            .toggleStyle(SettingsToggleStyle())
            Toggle(
                Strings.Settings.haptics,
                isOn: $viewModel.hapticEnabled
            )
            .toggleStyle(SettingsToggleStyle())
            Spacer()
            footer
        }
        .padding(EdgeInsets(top: 20, leading: 10, bottom: 5, trailing: 10))
    }
    
    @ViewBuilder
    private var moveToDebugPanelButton: some View {
        Button(action: viewModel.moveToDebugPanelTapped){
            Text(Strings.Settings.debugPanel)
        }
    }
    
    @ViewBuilder
    private var footer: some View {
        HStack(spacing: 4) {
            Text(Strings.Settings.Footer.prefix)
                .textStyle(.regularText, color: Colors.textGray2.swiftUIColor)
            Images.heart.swiftUIImage
            Text(Strings.Settings.Footer.suffix)
                .textStyle(.regularText, color: Colors.textGray2.swiftUIColor)
        }
    }
}

// MARK: - PreviewProvider

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView(
                viewModel: SettingsViewModel(
                    navigator: ScreenNavigator(window: UIWindow()),
                    screens: Screens()
                )
            )
        }
    }
}
