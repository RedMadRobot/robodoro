//
//  UserDefaultsStorage.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 12.12.2022.
//

import Foundation

// MARK: - Storages

protocol SettingsStorage {
    var soundEnabled: Bool { get set }
    var hapticEnabled: Bool { get set }
}

protocol LastUsedValuesStorage {
    var lastFocusTime: TimeInterval { get set }
    var lastBreakTime: TimeInterval { get set }
    var lastLongBreakTime: TimeInterval { get set }
    var lastStagesCount: Int { get set }
}

// MARK: - UserDefaultsStorage

final class UserDefaultsStorage: SettingsStorage,
                                 LastUsedValuesStorage {
    
    // MARK: - Keys
    
    enum Keys: String, CaseIterable {
        case soundEnabled = "com.redmadrobot.PomodoroApp.soundEnabled"
        case hapticEnabled = "com.redmadrobot.PomodoroApp.hapticEnabled"
        case lastFocusTime = "com.redmadrobot.PomodoroApp.lastFocusTime"
        case lastBreakTime = "com.redmadrobot.PomodoroApp.lastBreakTime"
        case lastLongBreakTime = "com.redmadrobot.PomodoroApp.lastLongBreakTime"
    }
    
    // MARK: - Private Properties
    
    private let storage: UserDefaults
    
    // MARK: - Initializers
    
    init(storage: UserDefaults) {
        self.storage = storage
        
        // SettingsStorage
        _soundEnabled = UserDefault(
            wrappedValue: true,
            key: Keys.soundEnabled.rawValue,
            storage: storage
        )
        _hapticEnabled = UserDefault(
            wrappedValue: true,
            key: Keys.hapticEnabled.rawValue,
            storage: storage
        )
        
        // LastUsedValuesStorage
        _lastFocusTime = UserDefault(
            wrappedValue: PomodoroState.focus.defaultWaitingTime,
            key: Keys.lastFocusTime.rawValue,
            storage: storage
        )
        _lastBreakTime = UserDefault(
            wrappedValue: PomodoroState.break.defaultWaitingTime,
            key: Keys.lastBreakTime.rawValue,
            storage: storage
        )
        _lastLongBreakTime = UserDefault(
            wrappedValue: PomodoroState.longBreak.defaultWaitingTime,
            key: Keys.lastLongBreakTime.rawValue,
            storage: storage
        )
        _lastStagesCount = UserDefault(
            wrappedValue: 4,
            key: Keys.lastLongBreakTime.rawValue,
            storage: storage
        )
    }
    
    // MARK: - SettingsStorage
    
    @UserDefault
    var soundEnabled: Bool
    @UserDefault
    var hapticEnabled: Bool
    
    // MARK: - LastUsedValuesStorage
    
    @UserDefault
    var lastFocusTime: TimeInterval
    @UserDefault
    var lastBreakTime: TimeInterval
    @UserDefault
    var lastLongBreakTime: TimeInterval
    @UserDefault
    var lastStagesCount: Int
}

// MARK: - Additional Types

protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    var isNil: Bool { self == nil }
}

@propertyWrapper
struct UserDefault<Value> {
    
    var wrappedValue: Value {
        get {
            let value = storage.object(forKey: key) as? Value
            return value ?? defaultValue
        }
        set {
            if let optional = newValue as? AnyOptional, optional.isNil {
                storage.removeObject(forKey: key)
            } else {
                storage.set(newValue, forKey: key)
            }
        }
    }

    private let key: String
    private let defaultValue: Value
    private let storage: UserDefaults

    init(
        wrappedValue defaultValue: Value,
        key: String,
        storage: UserDefaults
    ) {
        self.defaultValue = defaultValue
        self.key = key
        self.storage = storage
    }
}

extension UserDefault where Value: ExpressibleByNilLiteral {
    init(key: String, storage: UserDefaults) {
        self.init(wrappedValue: nil, key: key, storage: storage)
    }
}

@propertyWrapper
struct RawRepresentableUserDefault<Value: RawRepresentable> {
    
    var wrappedValue: Value {
        get {
            guard let rawValue = storage.object(forKey: key) as? Value.RawValue else {
                return defaultValue
            }
            return Value(rawValue: rawValue) ?? defaultValue
        }
        set {
            if let optional = newValue as? AnyOptional, optional.isNil {
                storage.removeObject(forKey: key)
            } else {
                storage.set(newValue.rawValue, forKey: key)
            }
        }
    }

    private let key: String
    private let defaultValue: Value
    private let storage: UserDefaults

    init(
        wrappedValue defaultValue: Value,
        key: String,
        storage: UserDefaults
    ) {
        self.defaultValue = defaultValue
        self.key = key
        self.storage = storage
    }
}

extension RawRepresentableUserDefault where Value: ExpressibleByNilLiteral {
    init(key: String, storage: UserDefaults) {
        self.init(wrappedValue: nil, key: key, storage: storage)
    }
}
