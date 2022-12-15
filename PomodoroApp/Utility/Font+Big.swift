//
//  Font+Big.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 17.11.2022.
//

import SwiftUI

extension Font {
    
    static var time: Font {
        unbounded(size: 64)
    }
    
    static var miniTime: Font {
        unbounded(size: 36)
    }
    
    static var customTitle: Font {
        unbounded(size: 16)
    }
    
    static var miniTitle: Font {
        cofoSans(size: 15)
    }
}
