//
//  Theme.swift
//  PomodoroApp
//
//  Created by Anna Kocheshkova on 17.01.2023.
//

import SwiftUI

enum ActivityViewTheme {
    case dark, light
}

extension ActivityViewTheme {
    var mainColor: Color {
        switch self {
        case .dark:
            return Colors.black.swiftUIColor
        case .light:
            return Colors.white.swiftUIColor
        }
    }
}
