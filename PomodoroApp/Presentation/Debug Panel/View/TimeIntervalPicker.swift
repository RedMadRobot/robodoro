//
//  TimeIntervalPicker.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 16.02.2023.
//

import SwiftUI

struct TimeIntervalPicker: View {
    
    // MARK: - Constants
    
    private enum Constants {
        static let secondsInMinute = 60
        static let secondsInHour = 3600
        static let maxHours = 10
    }
    
    // MARK: - Private Properties
    
    @Binding
    private var value: TimeInterval
    
    @State
    private var hours: Int = 0
    
    @State
    private var minutes: Int = 0
    
    @State
    private var seconds: Int = 0
    
    private let hoursArray = [Int](0...Constants.maxHours)
    private let minutesArray = [Int](0...59)
    private let secondsArray = [Int](0...59)
    
    private var maxInterval: TimeInterval {
        Double(Constants.maxHours * Constants.secondsInHour)
    }
    
    // MARK: - Init
    
    init(value: Binding<TimeInterval>) {
        self._value = value
    }
    
    // MARK: - View
    
    var body: some View {
        HStack(spacing: 0) {
            Picker(selection: $hours, label: Text("")) {
                ForEach(self.hoursArray, id: \.self) { hour in
                    Text("\(hour)")
                }
            }
            .onChange(of: hours) { hours in
                if hours == Constants.maxHours {
                    setPickers(h: hours, m: 0, s: 0)
                }
                recalculateInterval()
            }
            Text("h")
                .foregroundColor(Color(Colors.textGray1))
            Picker(selection: $minutes, label: Text("")) {
                ForEach(self.minutesArray, id: \.self) { minute in
                    Text("\(minute)")
                }
            }
            .onChange(of: minutes) { _ in
                guard hours != Constants.maxHours else {
                    setPickers(h: hours, m: 0, s: seconds)
                    return
                }
                recalculateInterval()
            }
            Text("m")
                .foregroundColor(Color(Colors.textGray1))
            Picker(selection: $seconds, label: Text("")) {
                ForEach(self.secondsArray, id: \.self) { second in
                    Text("\(second)")
                }
            }
            .onChange(of: seconds) { _ in
                guard hours != Constants.maxHours else {
                    setPickers(h: hours, m: minutes, s: 0)
                    return
                }
                recalculateInterval()
            }
            Text("s")
                .foregroundColor(Color(Colors.textGray1))
        }
        .pickerStyle(.wheel)
        .onChange(of: value) { _ in
            recalculatePickers()
        }
        .onAppear() {
            recalculatePickers()
        }
    }
    
    // MARK: - Private Methods
    
    private func recalculatePickers() {
        guard value <= maxInterval else {
            value = maxInterval
            return
        }
        
        var leftValue = Int(value)
        let hours = leftValue / Constants.secondsInHour
        leftValue -= hours * Constants.secondsInHour
        let minuts = leftValue / Constants.secondsInMinute
        leftValue -= minuts * Constants.secondsInMinute
        let seconds = leftValue
        setPickers(h: hours, m: minuts, s: seconds)
    }
    
    private func setPickers(
        h: Int,
        m: Int,
        s: Int
    ) {
        withAnimation {
            hours = h
            minutes = m
            seconds = s
        }
    }
    
    private func recalculateInterval() {
        let newValue = Double(
            hours * Constants.secondsInHour + minutes * Constants.secondsInMinute + seconds
        )
        guard newValue != value else { return }
        value = newValue
        print(value)
    }
}

// MARK: - PreviewProvider

struct TimeIntervalPicker_Previews: PreviewProvider {
    struct BindingValueHolder: View {
        
        @State var value: TimeInterval = 10 * 3600 + 25 * 60 + 30
        
        var body: some View {
            TimeIntervalPicker(value: $value)
        }
    }
    
    static var previews: some View {
        BindingValueHolder()
    }
}
