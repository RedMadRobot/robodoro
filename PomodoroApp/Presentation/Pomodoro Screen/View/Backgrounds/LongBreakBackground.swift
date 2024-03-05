//
//  LongBreakBackground.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 14.11.2022.
//

import SwiftUI

struct LongBreakBackground: View {
    
    // MARK: - Constants
    
    private enum Constants {
        static let initialY = CGFloat(45.35)
        static let xOffset = CGFloat(50)
        static let height = CGFloat(33.27)
        static let linesSpacing = CGFloat(135.54)
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

// MARK: - PreviewProvider

struct LongBreakBackground_Previews: PreviewProvider {
    static var previews: some View {
        LongBreakBackground(
            backgroundColor: Colors.longBreakGreen.swiftUIColor,
            strokeColor: Colors.longBreakLine.swiftUIColor
        )
    }
}
