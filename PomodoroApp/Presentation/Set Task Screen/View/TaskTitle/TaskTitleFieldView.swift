//
//  TaskTitleFieldView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 16.12.2022.
//

import SwiftUI

struct TaskTitleFieldView: View {
    
    // MARK: - Private Properties
    
    @Binding
    private var value: String
    
    @State
    private var textViewHeight: CGFloat = 0
    
    var onShouldChangeText: (NSRange, String) -> Bool
    
    // MARK: - Init
    
    init(
        value: Binding<String>,
        onShouldChangeText: @escaping (NSRange, String) -> Bool
    ) {
        self._value = value
        self.onShouldChangeText = onShouldChangeText
    }
    
    // MARK: - View
    
    var body: some View {
        CustomTextView(
            text: $value,
            calculatedHeight: $textViewHeight,
            onShouldChangeText: onShouldChangeText)
        .frame(minHeight: textViewHeight, maxHeight: textViewHeight)
        .padding(.vertical, 24)
        .padding(.horizontal, 20)
        .background(placeholderView, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Colors.gray.swiftUIColor))
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
    }
    
    // MARK: - Private Properties
    
    @ViewBuilder
    private var placeholderView: some View {
        if value.isEmpty {
            Text(Strings.SetTask.taskNamePlaceholder)
                .textStyle(.regularText, color: Colors.textGray2.swiftUIColor)
                .padding(.leading, 25)
                .padding(.top, 32)
        }
    }
}

// MARK: - PreviewProvider

struct TaskTitleFieldView_Previews: PreviewProvider {
    
    struct BindingValueHolder: View {
        
        @State var value: String = ""
        
        var body: some View {
            TaskTitleFieldView(
                value: $value,
                onShouldChangeText: { range, text in
                    let currentText = value
                    guard let stringRange = Range(range, in: currentText) else { return false }
                    let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
                    return updatedText.count <= 50
                })
        }
    }
  
    static var previews: some View {
        BindingValueHolder()
    }
}
