//
//  TimePickerView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 15.12.2022.
//

import SwiftUI
import Sliders

struct TimePickerView: View {
    
    // MARK: - Constants
    
    private enum Constants {
        static let minimumValue: TimeInterval = 5 * 60
        static let maximumValue: TimeInterval = 60 * 60
        static let step: TimeInterval = 5 * 60
    }
    
    // MARK: - Private Properties
    
    @Binding
    private var value: TimeInterval
    
    private let title: String
    private let color: UIColor
    
    private let dateComponentsFormatter: DateComponentsFormatter = .minutesAndSecondsFormatter
    
    // MARK: - Init
    
    init(
        value: Binding<TimeInterval>,
        title: String,
        color: UIColor
    ) {
        self._value = value
        self.title = title
        self.color = color
    }
    
    // MARK: - View
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(title)
                    .font(.miniTitle)
                Spacer()
                Text(dateComponentsFormatter.string(from: value) ?? "NaN")
                    .font(.miniTime)
            }
            ValueSlider(
                value: $value,
                in: Constants.minimumValue...Constants.maximumValue,
                step: Constants.step)
            .valueSliderStyle(
                HorizontalValueSliderStyle(
                    track: HorizontalTrack(view: Color(color))
                        .frame(height: 1)
                        .background(Color(Colors.defaultLine)),
                    thumb: Circle()
                        .fill(Color(color)),
                    thumbSize: CGSize(width: 20, height: 20)
                )
            )
            .frame(height: 20)
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - PreviewProvider

struct TimePickerView_Previews: PreviewProvider {
    
    struct BindingValueHolder: View {
        
        @State var value: TimeInterval = 25 * 60
        
        var body: some View {
            TimePickerView(
                value: $value,
                title: "Focus",
                color: Colors.longBreakGreen)
        }
    }
    
    static var previews: some View {
        BindingValueHolder()
    }
}
