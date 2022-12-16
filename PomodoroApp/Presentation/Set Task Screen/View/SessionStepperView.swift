//
//  SessionStepperView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 16.12.2022.
//

import SwiftUI

struct SessionStepperView: View {

    // MARK: - Constants
    
    private enum Constants {
        static let range = 1...10
    }

    // MARK: - Private Properties
    
    @Binding
    private var value: Int
    
    // MARK: - Init
    
    init(value: Binding<Int>) {
        self._value = value
    }
    
    // MARK: - View

    var body: some View {
        HStack {
            Text("Sessions")
                .font(.miniTitle)
            Spacer()
            stepperView
        }
        .padding(.horizontal, 16)
    }
    
    // MARK: - Private Properties
    
    @ViewBuilder
    private var stepperView: some View {
        HStack {
            Button {
                calculateNewValue(newValue: value - 1)
            } label: {
                Image(uiImage: Images.minus)
            }
            .disabled(value == Constants.range.lowerBound)
            Text("\(value)")
                .font(.miniTime)
                .frame(width: 48)
            Button {
                calculateNewValue(newValue: value + 1)
            } label: {
                Image(uiImage: Images.plus)
            }
            .disabled(value == Constants.range.upperBound)
        }
    }
    
    private func calculateNewValue(newValue: Int) {
        let constrainedValue = max(min(newValue, Constants.range.upperBound), Constants.range.lowerBound)
        value = constrainedValue
    }
}

// MARK: - PreviewProvider

struct SessionStepperView_Previews: PreviewProvider {
    
    struct BindingValueHolder: View {
        
        @State var value: Int = 4
        
        var body: some View {
            SessionStepperView(value: $value)
        }
    }
    
    static var previews: some View {
        BindingValueHolder()
    }
}
