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
        static let cofoSans = "CoFoSans-Regular"
    }
    
    // MARK: - Public Properties
    
    static var stageLabel: Font {
        unbounded(size: 14)
    }
    
    // MARK: - Public Methods
    
    static func unbounded(size: CGFloat) -> Font {
        .custom(Constants.unbounded, size: size)
    }
    
    static func cofoSans(size: CGFloat) -> Font {
        .custom(Constants.cofoSans, size: size)
    }
}
