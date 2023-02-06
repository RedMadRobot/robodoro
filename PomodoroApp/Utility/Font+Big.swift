//
//  Font+Big.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 17.11.2022.
//

import SwiftUI

extension Font {
    
    static var time: Font {
        unboundedBlond(size: 64)
    }
    
    static var miniTime: Font {
        unboundedBlond(size: 36)
    }
    
    static var bigTitle: Font {
        unboundedBlond(size: 32)
    }
    
    static var miniTitle: Font {
        cofoSans(size: 24)
    }
    
    static var screeenTitle: Font {
        unboundedRegular(size: 16)
    }
    
    static var regularText: Font {
        cofoSans(size: 15)
    }
}
