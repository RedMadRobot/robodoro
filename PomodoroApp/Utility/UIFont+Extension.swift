//
//  UIFont+Extension.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 22.12.2022.
//

import UIKit

extension UIFont {
    
    // MARK: - Constants
    
    private enum Constants {
        static let undoundedRegular = "Unbounded-Regular"
        static let unboundedBlond = "Unbounded-Blond"
        static let cofoSans = "CoFoSans-Regular"
    }
    
    // MARK: - Public Properties
    
    static var miniTitle: UIFont {
        cofoSans(size: 15)
    }
    
    // MARK: - Public Methods
    
    static func unboundedBlond(size: CGFloat) -> UIFont {
        UIFont(name: Constants.unboundedBlond, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func cofoSans(size: CGFloat) -> UIFont {
        UIFont(name: Constants.cofoSans, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
