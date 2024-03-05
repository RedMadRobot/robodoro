//
//  SpendedMinutesBlueBackground.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 19.12.2022.
//

import SwiftUI

struct SpendedMinutesBlueBackground: View {
    
    // MARK: - Constants
    
    private enum Constants {
        static let xOffset = CGFloat(11)
        static let yOffset = CGFloat(17)
        static let ellipsHeight = CGFloat(160)
        static let lineWidth = CGFloat(0.5)
    }
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            Colors.averageFocusBlue.swiftUIColor
            GeometryReader { geometry in
                Path { path in
                    let globalFrame = geometry.frame(in: .local)
                    let spacing = globalFrame.maxY / 4
                    let yCoordinates: [CGFloat] = [
                        -Constants.ellipsHeight + Constants.yOffset,
                         spacing - Constants.ellipsHeight / 2,
                         3 * spacing - Constants.ellipsHeight / 2,
                         globalFrame.maxY - Constants.yOffset
                    ]
                    for y in yCoordinates {
                        path.addEllipse(in: .init(
                            x: -Constants.xOffset,
                            y: y,
                            width: globalFrame.maxX + Constants.xOffset * 2,
                            height: Constants.ellipsHeight))
                    }
                }
                .stroke(Colors.averageFocusLine.swiftUIColor, lineWidth: Constants.lineWidth)
            }
        }
    }
}

// MARK: - PreviewProvider

struct SpendedMinutesBlueBackground_Previews: PreviewProvider {
    static var previews: some View {
        SpendedMinutesBlueBackground()
            .previewLayout(PreviewLayout.sizeThatFits)
            .frame(width: 177, height: 190)
    }
}
