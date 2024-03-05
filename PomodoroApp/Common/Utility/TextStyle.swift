//
//  TextStyle.swift
//  PomodoroApp
//
//  Created by Петр Тартынских on 05.03.2024.
//

import SwiftUI

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
    
    enum Font {
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
    
    var font: Font {
        switch self {
        case .stageLabel, .time, .miniTime, .bigTitle, .widgetBigTime, .widgetSmallTime:
            return .unboundedBlond
        case .miniTitle, .regularText:
            return .cofoSans
        case .regularTitle:
            return .unboundedRegular
        }
    }
    
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
}

extension Text {
    func textStyle(
        _ textStyle: TextStyle,
        color: Color? = Colors.black.swiftUIColor,
        lineLimit: Int? = nil
    ) -> some View {
        font(.custom(textStyle.font.stringName, size: textStyle.size))
            .lineLimit(lineLimit)
            .foregroundColor(color)
    }
}
