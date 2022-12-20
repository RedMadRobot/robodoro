//
//  TaskView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 20.12.2022.
//

import SwiftUI

struct TaskView: View {
    
    // MARK: - Private Properties
    
    private let task: PomodoroTask
    
    private var onDelete: () -> Void
    
    private let formatter: DateFormatter = .onlyDateFormatter
    
    // MARK: - Init
    
    init(
        task: PomodoroTask,
        onDelete: @escaping () -> Void
    ) {
        self.task = task
        self.onDelete = onDelete
    }
    
    // MARK: - View
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title ?? "Untitled")
                Text(formatter.string(from: task.date))
                    .foregroundColor(Color(Colors.textGray2))
            }
            .font(.miniTitle)
            Spacer()
            Text("\(task.completedInterval.minutesIgnoringHours)")
                .font(.miniTime)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
    }
    
    // MARK: - Private Properties
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
            onDelete: {})
    }
}
