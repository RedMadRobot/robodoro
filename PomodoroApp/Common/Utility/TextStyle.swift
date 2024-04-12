//
//  TextStyle.swift
//  PomodoroApp
//
//  Created by Петр Тартынских on 05.03.2024.
//

import SwiftUI

// MARK: - TextStyle

enum TextStyle {
    case stageLabel
    case time
    case miniTime
    case bigTitle
    case miniTitle
    case regularTitle
    case regularText
    case widgetBigTime
    case widgetSmallTime
    
    // MARK: - Private
    
    private enum FontFamily {
        case cofoSans
        case unboundedBlond
        case unboundedRegular
        
        var stringName: String {
            switch self {
            case .cofoSans:
                return Fonts.CoFoSans.regular.name
            case .unboundedBlond:
                return Fonts.Unbounded.blond.name
            case .unboundedRegular:
                return Fonts.Unbounded.regular.name
            }
        }
    }
    
    private var fontFamily: FontFamily {
        switch self {
        case .stageLabel, .time, .miniTime, .bigTitle, .widgetBigTime, .widgetSmallTime:
            return .unboundedBlond
        case .miniTitle, .regularText:
            return .cofoSans
        case .regularTitle:
            return .unboundedRegular
        }
    }
    
    // MARK: - Public
    
    var size: CGFloat {
        switch self {
        case .stageLabel:
            return 14
        case .time:
            return 64
        case .miniTime:
            return 36
        case .bigTitle:
            return 32
        case .miniTitle:
            return 24
        case .regularTitle:
            return 16
        case .regularText:
            return 15
        case .widgetBigTime:
            return 56
        case .widgetSmallTime:
            return 48
        }
    }
    
    var swiftUiFont: SwiftUI.Font {
        SwiftUI.Font(uiFont)
    }
    
    var uiFont: UIFont {
        UIFont(name: fontFamily.stringName, size: size) ?? .systemFont(ofSize: size)
    }
}

// MARK: - Text+TextStyle

extension Text {
    func textStyle(
        _ textStyle: TextStyle,
        color: Color? = Colors.black.swiftUIColor,
        lineLimit: Int? = nil
    ) -> some View {
        font(textStyle.swiftUiFont)
            .lineLimit(lineLimit)
            .foregroundColor(color)
    }
}
