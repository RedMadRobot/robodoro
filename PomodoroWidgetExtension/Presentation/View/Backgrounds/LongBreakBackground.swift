//
//  LongBreakBackground.swift
//  PomodoroWidgetExtension
//
//  Created by Петр Тартынских  on 17.11.2022.
//

import SwiftUI

struct LongBreakBackground: View {
    
    // MARK: - Constants
    
    private enum Constants {
        static let initialY = CGFloat(3)
        static let xOffset = CGFloat(50)
        static let height = CGFloat(15.61)
        static let linesSpacing = CGFloat(75.22)
        static let frequency = CGFloat(0.013)
        static let lineWidth = CGFloat(0.5)
    }
    
    // MARK: - Private Properties
    
    private let backgroundColor: Color
    private let strokeColor: Color
    
    // MARK: - Init
    
    init(backgroundColor: Color, strokeColor: Color) {
        self.backgroundColor = backgroundColor
        self.strokeColor = strokeColor
    }
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            backgroundColor
            GeometryReader { geometry in
                Path { path in
                    let globalFrame = geometry.frame(in: .global)
                    let width = globalFrame.maxX
                    var y = Constants.initialY
                    while y - Constants.height < globalFrame.maxY {
                        path.move(to: .init(x: -Constants.xOffset, y: y))
                        for x in stride(from: 0, through: width, by: 1) {
                            let y = Constants.height * sin(Constants.frequency * (x + Constants.xOffset)) + y
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                        y += Constants.linesSpacing
                    }
                    
                }
                .stroke(strokeColor, lineWidth: Constants.lineWidth)
            }
        }
        .ignoresSafeArea()
    }
}
