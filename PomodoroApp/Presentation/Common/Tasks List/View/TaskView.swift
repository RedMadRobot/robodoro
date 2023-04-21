//
//  TaskView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 20.12.2022.
//

import SwiftUI

struct TaskView: View {
    
    // MARK: - Constants
    
    private enum Constants {
        static let offset = CGFloat(56)
        static let buttonSpacing = CGFloat(32)
        static let buttonPadding = CGFloat(10)
    }
    
    // MARK: - Private Properties
    
    private let task: PomodoroTaskItem
    
    private var isEditing: Bool
    
    private var onTap: () -> Void
    private var onDelete: () -> Void
        
    // MARK: - Init
    
    init(
        task: PomodoroTaskItem,
        isEditing: Bool,
        onTap: @escaping () -> Void,
        onDelete: @escaping () -> Void
    ) {
        self.task = task
        self.isEditing = isEditing
        self.onTap = onTap
        self.onDelete = onDelete
    }
    
    // MARK: - View
    
    var body: some View {
        frontView
            .offset(x: isEditing ? -Constants.offset : .zero)
            .mask(LinearGradient(gradient: Gradient(stops: [
                .init(color: .clear, location: 0),
                .init(color: .black, location: 0.05),
            ]), startPoint: .leading, endPoint: .trailing))
            .animation(.interactiveSpring(), value: isEditing)
            .contentShape(Rectangle())
            .onTapGesture {
                onTap()
            }
    }
    
    // MARK: - Private Properties
    
    @ViewBuilder
    private var frontView: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
//                Text(task.title ?? "Noname Task")
                Text(task.title)
//                Text(formatDate())
                Text(task.date)
                    .foregroundColor(Colors.textGray2.suColor)
            }
            .font(.regularText)
            Spacer(minLength: 45)
//            Text("\(task.completedInterval.minutesIgnoringHours)")
            Text(task.completedInterval)
                .font(.miniTime)
                .contentShape(Rectangle())
                .background(GeometryReader { geometry in
                    Button {
                        onDelete()
                    } label: {
                        Images.trash.suImage
                            .padding(.all, Constants.buttonPadding)
                    }
                    .offset(
                        x: geometry.size.width - Constants.buttonPadding + Constants.buttonSpacing,
                        y: geometry.size.height / 4 - Constants.buttonPadding)
                })
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
    }
    
    // MARK: - Private Methods
    
//    private func formatDate() -> String {
//        let formatter: DateFormatter = .onlyDateFormatter
//        return formatter.string(from: task.date)
//    }
}

// MARK: - PreviewProvider

struct TaskView_Previews: PreviewProvider {
    
    static var previews: some View {
        TaskView(
            task: PomodoroTaskItem(task: .init(
                id: UUID(),
                title: nil,
                date: Date(),
                completedInterval: 60 * 60 * 10)),
            isEditing: false,
            onTap: {},
            onDelete: {})
    }
}
