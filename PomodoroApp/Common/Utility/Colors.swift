//
//  Colors.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 14.11.2022.
//

import SwiftUI

enum Colors {
    static let defaultGray = UIColor("#F4F4F4")
    static let defaultLine = UIColor("#D6D6D6")
    static let focusRed = UIColor("#EF5D42")
    static let focusLine = UIColor("#C54E39")
    static let breakPurple = UIColor("#D399EE")
    static let breakLine = UIColor("#B17FC8")
    static let longBreakGreen = UIColor("#95CC6A")
    static let longBreakLine = UIColor("#76A552")
    static let black = UIColor("#000000")
    static let white = UIColor ("#FFFFFF")
    static let gray = UIColor("#F3F3F3")
    static let textGray1 = UIColor("#A4A4A4")
    static let textGray2 = UIColor("#C1C1C1")
    static let toggleGreen = UIColor("#82C762")
    static let averageFocusBlue = UIColor("#99E4EE")
    static let averageFocusLine = UIColor("#5DCDDE")
}

extension UIColor {
    var suColor: Color { Color(self) }
}
