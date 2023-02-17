//
//  CustomTextField.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 16.02.2023.
//

import SwiftUI

struct CustomTextField: UIViewRepresentable {
    
    // MARK: - Coordinator

    class Coordinator: NSObject, UITextFieldDelegate {
        var text: Binding<String>
        var onShouldChangeText: (NSRange, String) -> Bool

        init(
            text: Binding<String>,
            onShouldChangeText: @escaping (NSRange, String) -> Bool
        ) {
            self.text = text
            self.onShouldChangeText = onShouldChangeText
        }

        @objc
        func textChanged(_ textField: UITextField) {
            text.wrappedValue = textField.text ?? ""
        }
        
        func textField(
            _ textField: UITextField,
            shouldChangeCharactersIn range: NSRange,
            replacementString string: String
        ) -> Bool {
            if string == "\n" {
                textField.resignFirstResponder()
                return false
            }
            return onShouldChangeText(range, string)
        }
    }

    // MARK: - Public Properties

    @Binding
    var text: String
    var placeholder: String?
    
    var onShouldChangeText: (NSRange, String) -> Bool

    // MARK: - UIViewRepresentable

    func makeUIView(context: Context) -> some UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.delegate = context.coordinator
        textField.returnKeyType = .done
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textField.addTarget(context.coordinator, action: #selector(context.coordinator.textChanged), for: .editingChanged)
        return textField
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(
            text: $text,
            onShouldChangeText: onShouldChangeText)
    }
}
