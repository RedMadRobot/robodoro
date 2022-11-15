//
//  Font+Extension.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 15.11.2022.
//

import SwiftUI

extension Font {
    
    // MARK: - Constants
    
    private enum Constants {
        static let unbounded = "Unbounded-Blond"
    }
    
    // MARK: - Public Properties
    
    static var stageLabel: Font {
        unbounded(size: 14)
    }
    
    static var time: Font {
        unbounded(size: 64)
    }
    
    static var activityTime: Font {
        unbounded(size: 56)
    }
    
    // MARK: - Private Methods
    
    private static func unbounded(size: CGFloat) -> Font {
        .custom(Constants.unbounded, size: size)
    }
}
