//
//  Theme.swift
//  PomodoroApp
//
//  Created by Anna Kocheshkova on 17.01.2023.
//

import UIKit

enum ActivityViewTheme {
    case dark, light
}

extension ActivityViewTheme {
    var mainColor: UIColor {
        switch self {
        case .dark:
            return Colors.black
        case .light:
            return Colors.white
        }
    }
}
