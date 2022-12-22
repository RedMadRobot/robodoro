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
        static let unbounded = "Unbounded-Blond"
        static let cofoSans = "CoFoSans-Regular"
    }
    
    // MARK: - Public Properties
    
    static var miniTitle: UIFont {
        cofoSans(size: 15)
    }
    
    // MARK: - Public Methods
    
    static func unbounded(size: CGFloat) -> UIFont {
        UIFont(name: Constants.unbounded, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func cofoSans(size: CGFloat) -> UIFont {
        UIFont(name: Constants.cofoSans, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
