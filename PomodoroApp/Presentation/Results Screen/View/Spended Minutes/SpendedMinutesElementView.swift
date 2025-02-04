//
//  SpendedMinutesElementView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 19.12.2022.
//

import SwiftUI

enum SpendedMinutesElementViewStyle {
    case red
    case blue
}

struct SpendedMinutesElementView: View {
    
    // MARK: - Private Properties
    
    private let value: Double
    private let title: String
    private let style: SpendedMinutesElementViewStyle
    
    private let numberFormatter: NumberFormatter = .oneSignificantDigitFormatter
    
    // MARK: - Init
    
    init(
        value: Double,
        title: String,
        style: SpendedMinutesElementViewStyle
    ) {
        self.value = value
        self.title = title
        self.style = style
    }
    
    // MARK: - View
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(numberFormatter.getValue(double: value))
                    .textStyle(.miniTime)
                Spacer()
                Text(title)
                    .textStyle(.regularText)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .background(backgroundView)
        .frame(maxWidth: .infinity)
        .frame(height: 190)
        .clipShape(RoundedRectangle(cornerRadius: 32))
    }
    
    // MARK: - Private Properties
    
    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .red:
            SpendedMinutesRedBackground()
        case .blue:
            SpendedMinutesBlueBackground()
        }
    }
}

// MARK: - PreviewProvider

struct SpendedMinutesElementView_Previews: PreviewProvider {
    static var previews: some View {
        SpendedMinutesElementView(
            value: 100,
            title: "Daily average\nfocus, min",
            style: .blue)
        .frame(width: 177)
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}
