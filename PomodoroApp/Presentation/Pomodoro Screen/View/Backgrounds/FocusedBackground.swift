//
//  FocusedBackground.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 14.11.2022.
//

import SwiftUI

struct FocusedBackground: View {
    
    // MARK: - Constants
    
    private enum Constants {
        static let radius = CGFloat(1000)
        static let numberOfLines = 12
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
                    let center = CGPoint(
                        x: geometry.frame(in: .global).midX,
                        y: geometry.frame(in: .global).midY)
                    for i in 0...Constants.numberOfLines {
                        path.move(to: center)
                        path.addLine(
                            to: .init(
                                x: center.x + Constants.radius * cos(
                                    degrees: Double(i) * 360 / Double(Constants.numberOfLines)),
                                y: center.y + Constants.radius * sin(
                                    degrees: Double(i) * 360 / Double(Constants.numberOfLines))))
                    }
                }
                .stroke(strokeColor, lineWidth: Constants.lineWidth)
            }
        }
        .ignoresSafeArea()
    }
    
    // MARK: - Private Methods
    
    private func sin(degrees: Double) -> Double {
        return __sinpi(degrees/180.0)
    }
    
    private func cos(degrees: Double) -> Double {
        return __cospi(degrees/180.0)
    }
}

// MARK: - PreviewProvider

struct FocusedBackground_Previews: PreviewProvider {
    static var previews: some View {
        FocusedBackground(
            backgroundColor: Colors.focusRed.swiftUIColor,
            strokeColor: Colors.focusLine.swiftUIColor
        )
    }
}
