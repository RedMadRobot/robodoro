//
//  StageElementView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 15.11.2022.
//

import SwiftUI

enum StageElementViewState: Codable, Hashable {
    case empty
    case half
    case filled
}

struct StageElementView: View {
    
    // MARK: - Constants
    
    private enum Constants {
        static let lineWidth = CGFloat(1)
        static let frameSize = CGFloat(8)
    }
    
    // MARK: - Private Properties
    
    private var state: StageElementViewState
    private var theme: ActivityViewTheme
    
    // MARK: - Init
    
    init(
        state: StageElementViewState,
        theme: ActivityViewTheme
    ) {
        self.state = state
        self.theme = theme
    }
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(theme.mainColor, lineWidth: Constants.lineWidth)
                .frame(width: Constants.frameSize)
            switch state {
            case .empty:
                EmptyView()
            case .half:
                Circle()
                    .trim(from: 0, to: 0.5)
                    .fill(theme.mainColor)
                    .frame(width: Constants.frameSize, height: Constants.frameSize)
                    .rotationEffect(.degrees(90))
            case .filled:
                Circle()
                    .fill(theme.mainColor)
                    .frame(width: Constants.frameSize, height: Constants.frameSize)
            }
        }
        .animation(.easeInOut, value: state)
    }
}

// MARK: - PreviewProvider

struct StageElementView_Previews: PreviewProvider {
    static var previews: some View {
        StageElementView(state: .half, theme: .dark)
    }
}
