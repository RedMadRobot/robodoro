//
//  CustomTextView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 22.12.2022.
//

import SwiftUI

struct CustomTextView: UIViewRepresentable {
    
    // MARK: - Coordinator
    
    class Coordinator: NSObject, UITextViewDelegate {
        var text: Binding<String>
        var calculatedHeight: Binding<CGFloat>
        var onShouldChangeText: (NSRange, String) -> Bool
        
        init(
            text: Binding<String>,
            calculatedHeight: Binding<CGFloat>,
            onShouldChangeText: @escaping (NSRange, String) -> Bool
        ) {
            self.text = text
            self.calculatedHeight = calculatedHeight
            self.onShouldChangeText = onShouldChangeText
        }
        
        func textViewDidChange(_ textView: UITextView) {
            text.wrappedValue = textView.text
            CustomTextView.recalculateHeight(view: textView, result: calculatedHeight)
        }
        
        func textView(
            _ textView: UITextView,
            shouldChangeTextIn range: NSRange,
            replacementText text: String
        ) -> Bool {
            if text == "\n" {
                textView.resignFirstResponder()
                return false
            }
            return onShouldChangeText(range, text)
        }
    }
    
    // MARK: - Public Properties
    
    @Binding
    var text: String
    
    @Binding
    var calculatedHeight: CGFloat
    
    var onShouldChangeText: (NSRange, String) -> Bool
        
    // MARK: - UIViewRepresentable
    
    func makeUIView(context: Context) -> some UITextView {
        let textView = UITextView()
        textView.font = .miniTitle
        textView.backgroundColor = .clear
        textView.delegate = context.coordinator
        textView.returnKeyType = .done
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        CustomTextView.recalculateHeight(view: uiView, result: $calculatedHeight)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(
            text: $text,
            calculatedHeight: $calculatedHeight,
            onShouldChangeText: onShouldChangeText)
    }
    
    // MARK: - Priate Methods
    
    fileprivate static func recalculateHeight(view: UIView, result: Binding<CGFloat>) {
        let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if result.wrappedValue != newSize.height {
            DispatchQueue.main.async {
                result.wrappedValue = newSize.height
            }
        }
    }
}
