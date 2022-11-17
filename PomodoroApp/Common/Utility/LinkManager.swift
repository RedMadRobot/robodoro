//
//  LinkManager.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 17.11.2022.
//

import Foundation

// MARK: - LinkManager

final class LinkManager {
    
    // MARK: - Types
    
    enum Action {
        case mainButtonAction
    }
    
    // MARK: - Constants
    
    private enum Constants {
        static let scheme = "pomodoroApp"
        static let host = "timer"
        static let buttonActionPath = "/buttonAction"
    }
    
    // MARK: - Public Properties
    
    static var buttonActionURL: URL {
        var components = URLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.host
        components.path = Constants.buttonActionPath
        return components.url!
    }
    
    // MARK: - Public Mehtods
    
    static func manage(url: URL) -> Action? {
        guard url.scheme == Constants.scheme,
              url.host == Constants.host,
              url.path == Constants.buttonActionPath,
              url.query == nil else { return nil }
        return .mainButtonAction
    }
}
