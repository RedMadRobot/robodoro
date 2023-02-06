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
        static let undoundedRegular = "Unbounded-Regular"
        static let unboundedBlond = "Unbounded-Blond"
        static let cofoSans = "CoFoSans-Regular"
    }
    
    // MARK: - Public Properties
    
    static var stageLabel: Font {
        unboundedBlond(size: 14)
    }
    
    // MARK: - Public Methods
    
    static func unboundedRegular(size: CGFloat) -> Font {
        .custom(Constants.undoundedRegular, size: size)
    }
    
    static func unboundedBlond(size: CGFloat) -> Font {
        .custom(Constants.unboundedBlond, size: size)
    }
    
    static func cofoSans(size: CGFloat) -> Font {
        .custom(Constants.cofoSans, size: size)
    }
}
