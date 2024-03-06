//
//  NoTasksView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 12.12.2022.
//

import SwiftUI

struct NoTasksView: View {
   
    // MARK: - Constants
    
    private enum Constants {
        static let initialY = CGFloat(80)
        static let spacingMultiplyer = CGFloat(1.3)
        static let lineWidth = CGFloat(0.5)
    }
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            backView
            Text(Strings.ResultsScreen.noTasks)
                .textStyle(.stageLabel, color: Colors.textGray1.swiftUIColor)
        }
        .ignoresSafeArea()
    }
    
    // MARK: - Private Properties
    
    @ViewBuilder
    private var backView: some View {
        Colors.defaultGray.swiftUIColor
        GeometryReader { geometry in
            Path { path in
                let globalFrame = geometry.frame(in: .global)
                let centerX = globalFrame.midX
                let radius = globalFrame.maxX / 2
                let spacing = radius * Constants.spacingMultiplyer
                var y = Constants.initialY
                while y - radius < globalFrame.maxY {
                    path.addArc(
                        center: CGPoint(x: centerX, y: y),
                        radius: radius,
                        startAngle: .degrees(0),
                        endAngle: .degrees(360),
                        clockwise: true)
                    
                    y += spacing
                }
            }
            .stroke(Colors.defaultLine.swiftUIColor, lineWidth: Constants.lineWidth)
        }
    }
}

// MARK: - PreviewProvider

struct NoTasksView_Previews: PreviewProvider {
    static var previews: some View {
        NoTasksView()
    }
}
