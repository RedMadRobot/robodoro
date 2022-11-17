//
//  BreakBackground.swift
//  PomodoroWidgetExtensionExtension
//
//  Created by Петр Тартынских  on 17.11.2022.
//

import SwiftUI

struct BreakBackground: View {
    
    // MARK: - Constants
    
    private enum Constants {
        static let coodrdinates: [CGFloat] = [21.0, 50.93, 109.54, 186.86, 307.82]
        static let lineWidth = CGFloat(0.5)
    }
    
    // MARK: - Private Properties
    
    private let backgroundColor: UIColor
    private let strokeColor: UIColor
    
    // MARK: - Init
    
    init(backgroundColor: UIColor, strokeColor: UIColor) {
        self.backgroundColor = backgroundColor
        self.strokeColor = strokeColor
    }
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            Color(backgroundColor)
            GeometryReader { geometry in
                Path { path in
                    let globalFrame = geometry.frame(in: .global)
                    for coordinate in Constants.coodrdinates {
                        path.move(
                            to: .init(
                                x: coordinate,
                                y: globalFrame.minY))
                        path.addLine(
                            to: .init(
                                x: coordinate,
                                y: globalFrame.maxY))
                    }
                }
                .stroke(Color(strokeColor), lineWidth: Constants.lineWidth)
            }
        }
        .ignoresSafeArea()
    }
}
