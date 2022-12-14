//
//  AppStorages.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 12.12.2022.
//

import Foundation

final class AppStorages {
    
    lazy var userDefaultsStorage = UserDefaultsStorage(storage: .standard)
}
