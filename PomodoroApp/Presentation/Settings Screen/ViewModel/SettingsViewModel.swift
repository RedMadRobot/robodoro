//
//  SettingsViewModel.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 14.12.2022.
//

import SwiftUI

final class SettingsViewModel: ObservableObject {
    
    // MARK: - Public Properties
    
    @Published
    var soundEnabled: Bool {
        didSet {
            userDefaultsStorage.soundEnabled = soundEnabled
        }
    }
    
    @Published
    var hapticEnabled: Bool {
        didSet {
            userDefaultsStorage.hapticEnabled = hapticEnabled
        }
    }
    
    // MARK: - Private Properties
    
    private let userDefaultsStorage: UserDefaultsStorage
        
    // MARK: - Init
    
    init(userDefaultsStorage: UserDefaultsStorage = DI.storages.userDefaultsStorage) {
        self.userDefaultsStorage = userDefaultsStorage
        self.soundEnabled = userDefaultsStorage.soundEnabled
        self.hapticEnabled = userDefaultsStorage.hapticEnabled
    }
}
