//
//  SpendedMunutesRedBackground.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 19.12.2022.
//

import SwiftUI

struct SpendedMinutesRedBackground: View {
    
    // MARK: - Constants
    
    private enum Constants {
        static let xOffset = CGFloat(20)
        static let yOffset = CGFloat(40)
        static let radius = CGFloat(500)
        static let numberOfLines = 12
        static let lineWidth = CGFloat(0.5)
    }
    
    // MARK: - View
        
    var body: some View {
        ZStack {
            Color(Colors.focusRed)
            GeometryReader { geometry in
                Path { path in
                    let center = CGPoint(
                        x: geometry.frame(in: .local).maxX - Constants.xOffset,
                        y: geometry.frame(in: .local).maxY - Constants.yOffset)
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
                .stroke(Color(Colors.focusLine), lineWidth: Constants.lineWidth)
            }
        }
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

struct SpendedMinutesRedBackground_Previews: PreviewProvider {
    static var previews: some View {
        SpendedMinutesRedBackground()
            .previewLayout(PreviewLayout.sizeThatFits)
            .frame(width: 177, height: 190)
    }
}
