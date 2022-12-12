//
//  UserDefaultsStorage.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 12.12.2022.
//

import Foundation

protocol SettingsStorage {
    var enableSound: Bool { get set }
    var enableHaptic: Bool { get set }
}

private protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    var isNil: Bool { self == nil }
}

// MARK: - Wrappers

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

final class UserDefaultsStorage: SettingsStorage {
    
    // MARK: - Keys
    
    enum Keys: String, CaseIterable {
        case enableSound = "com.redmadrobot.PomodoroApp.enableSound"
        case enableHaptic = "com.redmadrobot.PomodoroApp.enableHaptic"
    }
    
    // MARK: - Private Properties
    
    private let userDefaultsStorage: UserDefaults
    
    // MARK: - Initializers
    
    init(storage: UserDefaults) {
        self.userDefaultsStorage = storage
        
        // SettingsStorage
        _enableSound = UserDefault(
            wrappedValue: false,
            key: Keys.enableSound.rawValue,
            storage: userDefaultsStorage
        )
        _enableHaptic = UserDefault(
            wrappedValue: false,
            key: Keys.enableHaptic.rawValue,
            storage: userDefaultsStorage
        )
    }
    
    // MARK: - SettingsStorage
    
    @UserDefault
    var enableSound: Bool
    @UserDefault
    var enableHaptic: Bool
}
