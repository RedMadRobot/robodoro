//
//  SettingsView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 12.12.2022.
//

import SwiftUI

struct SettingsView: View {
    
    // MARK: - Private Properties
    
    @ObservedObject
    private var navigator: MainNavigator
    
    // MARK: - Init
    
    init(
        navigator: MainNavigator
    ) {
        self.navigator = navigator
    }
    
    // MARK: - View
    
    var body: some View {
        Text("Settings")
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
                        .font(.customTitle)
                }
            }
    }
}

// MARK: - PreviewProvider

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(
            navigator: MainNavigator()
        )
    }
}
