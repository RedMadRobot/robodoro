//
//  StageView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 15.11.2022.
//

import SwiftUI

struct StageView: View {
    
    // MARK: - Constants
    
    private enum Constants {
        static let spacing = CGFloat(6)
    }
    
    // MARK: - Private Properties
    
    private let stagesCount: Int
    private let filledCount: Int
    
    // MARK: - Init
    
    init(
        stagesCount: Int,
        filledCount: Int
    ) {
        self.stagesCount = stagesCount
        self.filledCount = filledCount
    }
    
    // MARK: - View
    
    var body: some View {
        HStack(spacing: Constants.spacing) {
            ForEach(0..<stagesCount, id: \.self) { stage in
                StageElementView(isFilled: stage < filledCount)
            }
        }
    }
}

// MARK: - PreviewProvider

struct StageView_Previews: PreviewProvider {
    static var previews: some View {
        StageView(stagesCount: 4, filledCount: 3)
    }
}
