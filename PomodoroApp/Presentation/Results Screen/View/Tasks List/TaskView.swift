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
    }
    
    // MARK: - Private Properties
    
    private let task: PomodoroTask
    
    private var isEditing: Bool
    
    private var onTap: () -> Void
    private var onDelete: () -> Void
    
    private let formatter: DateFormatter = .onlyDateFormatter
    
    // MARK: - Init
    
    init(
        task: PomodoroTask,
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
        .onTapGesture {
            onTap()
        }
        .animation(.interactiveSpring(), value: isEditing)
    }
    
    // MARK: - Private Properties
    
    @ViewBuilder
    private var frontView: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title ?? "Untitled")
                Text(formatter.string(from: task.date))
                    .foregroundColor(Color(Colors.textGray2))
            }
            .font(.miniTitle)
            Text("\(task.completedInterval.minutesIgnoringHours)")
                .font(.miniTime)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .contentShape(Rectangle())
                .background(GeometryReader { geometry in
                    Button {
                        onDelete()
                    } label: {
                        Image(uiImage: Images.trash)
                    }
                    .offset(x: geometry.size.width + Constants.buttonSpacing, y: geometry.size.height / 4)
                })
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
    }
}

// MARK: - PreviewProvider

struct TaskView_Previews: PreviewProvider {
    
    static var previews: some View {
        TaskView(
            task: .init(
                id: UUID(),
                title: nil,
                date: Date(),
                completedInterval: 60 * 60 * 10),
            isEditing: false,
            onTap: {},
            onDelete: {})
    }
}
