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
    
    // MARK: - Init
    
    init(value: Binding<String>) {
        self._value = value
    }
    
    // MARK: - View
    
    var body: some View {
        TextField("Add task name, if you want...", text: $value, axis: .vertical)
            .font(.miniTitle)
            .padding(.vertical, 24)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(Colors.gray)))
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
    }
}

// MARK: - PreviewProvider

struct TaskTitleFieldView_Previews: PreviewProvider {
    
    struct BindingValueHolder: View {
        
        @State var value: String = ""
        
        var body: some View {
            TaskTitleFieldView(value: $value)
        }
    }
    
    static var previews: some View {
        BindingValueHolder()
    }
}
