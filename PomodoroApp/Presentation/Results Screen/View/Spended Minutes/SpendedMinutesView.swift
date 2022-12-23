//
//  SpendedMinutesView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 19.12.2022.
//

import SwiftUI

struct SpendedMinutesView: View {
    
    // MARK: - Private Properties
    
    private let dailyAverageFocusValue: Double
    private let totalFocusValue: Double
    
    // MARK: - Init
    
    init(
        dailyAverageFocusValue: Double,
        totalFocusValue: Double
    ) {
        self.dailyAverageFocusValue = dailyAverageFocusValue
        self.totalFocusValue = totalFocusValue
    }
    
    // MARK: - View
    
    var body: some View {
        HStack(spacing: 8) {
            SpendedMinutesElementView(
                value: dailyAverageFocusValue,
                title: "Daily average\nfocus, min",
                style: .blue)
            .animation(.easeInOut, value: dailyAverageFocusValue)
            SpendedMinutesElementView(
                value: totalFocusValue,
                title: "Total focus,\n min",
                style: .red)
            .animation(.easeInOut, value: totalFocusValue)
        }
    }
    
    // MARK: - Private Properties
    
}

// MARK: - PreviewProvider

struct SpendedMinutesView_Previews: PreviewProvider {
    static var previews: some View {
        SpendedMinutesView(
            dailyAverageFocusValue: 50,
            totalFocusValue: 132)
    }
}
