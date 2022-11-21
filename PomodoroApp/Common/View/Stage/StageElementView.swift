//
//  StageElementView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 15.11.2022.
//

import SwiftUI

struct StageElementView: View {
    
    // MARK: - Constants
    
    private enum Constants {
        static let lineWidth = CGFloat(1)
        static let frameSize = CGFloat(8)
    }
    
    // MARK: - Private Properties
    
    private var isFilled: Bool
    
    // MARK: - Init
    
    init(isFilled: Bool) {
        self.isFilled = isFilled
    }
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(uiColor: Colors.element), lineWidth: Constants.lineWidth)
                .frame(width: Constants.frameSize)
            if isFilled {
                Circle()
                    .fill(Color(uiColor: Colors.element))
                    .frame(width: Constants.frameSize, height: Constants.frameSize)
            }
        }
        .animation(.easeInOut, value: isFilled)
    }
}

// MARK: - PreviewProvider

struct StageElementView_Previews: PreviewProvider {
    static var previews: some View {
        StageElementView(isFilled: false)
    }
}
