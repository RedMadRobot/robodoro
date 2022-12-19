//
//  SpendedMinutesView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 19.12.2022.
//

import SwiftUI

struct SpendedMinutesView: View {
    
    // MARK: - Private Properties
    
    private let dailyAverageFocusValue: Int
    private let totalFocusValue: Int
    
    // MARK: - Init
    
    init(
        dailyAverageFocusValue: Int,
        totalFocusValue: Int
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
            SpendedMinutesElementView(
                value: totalFocusValue,
                title: "Total focus,\n min",
                style: .red)
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
