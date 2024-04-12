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
    
    enum Action: String {
        case start
        case stop
        case pause
    }
    
    // MARK: - Constants
    
    private enum Constants {
        static let scheme = "pomodoroApp"
        static let host = "pomodoro"
        static let timerPath = "/timer"
        static let actionQueryName = "action"
    }
    
    // MARK: - Public Mehtods
    
    static func buttonActionURL(action: String) -> URL {
        var components = URLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.host
        components.path = Constants.timerPath
        components.queryItems = [
            URLQueryItem(name: Constants.actionQueryName, value: action)
        ]
        return components.url!
    }
    
    static func getAction(from url: URL) -> Action? {
        guard url.scheme == Constants.scheme,
              url.host == Constants.host,
              url.path == Constants.timerPath,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let actionString = components.queryItems?.first?.value,
              let action = Action(rawValue: actionString) else { return nil }
        return action
    }
}
