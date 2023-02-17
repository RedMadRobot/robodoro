//
//  TasksListView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 20.12.2022.
//

import SwiftUI

struct TasksListView: View {
    
    // MARK: - Private Properties
    
    @State
    private var editingTask: PomodoroTask?
    
    private let tasks: [PomodoroTask]
    private let disableAnimations: Bool
    
    private var onDelete: ((PomodoroTask) -> Void)?
    
    // MARK: - Init
    
    init(
        tasks: [PomodoroTask],
        disableAnimations: Bool = false,
        onDelete: ((PomodoroTask) -> Void)? = nil
    ) {
        self.tasks = tasks
        self.disableAnimations = disableAnimations
        self.onDelete = onDelete
    }
    
    // MARK: - View
    
    var body: some View {
        LazyVStack(spacing: 0) {
            titleView
            tableView
        }
        .background(
            RoundedRectangle(cornerRadius: 32)
                .fill(Color(Colors.white)))
        .animation(disableAnimations ? nil : .easeInOut, value: tasks)
    }
    
    // MARK: - Private Properties
    
    @ViewBuilder
    private var titleView: some View {
        HStack {
            Text("Task")
            Spacer()
            Text("Focus, min")
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
        .font(.regularText)
        .foregroundColor(Color(Colors.textGray2))
    }
    
    @ViewBuilder
    private var tableView: some View {
        ForEach(tasks, id: \.id) { task in
            TaskView(
                task: task,
                isEditing: task == editingTask,
                onTap: {
                    onRowTapped(task: task)
                },
                onDelete: {
                    editingTask = nil
                    onDelete?(task)
                })
            if task != tasks.last {
                divider
            }
        }
    }
    
    @ViewBuilder
    private var divider: some View {
        Divider()
            .overlay(Color(Colors.textGray2))
            .padding(.horizontal, 16)
    }
    
    // MARK: - Private Methods
    
    private func onRowTapped(task: PomodoroTask) {
        guard let _ = onDelete else { return }
        if task == editingTask {
            editingTask = nil
        } else {
            editingTask = task
        }
    }
}

// MARK: - PreviewProvider

struct TasksListView_Previews: PreviewProvider {
    
    static var previews: some View {
        ZStack {
            Color(Colors.gray)
                .ignoresSafeArea()
            ScrollView {
                TasksListView(
                    tasks: Array(1...10).map {
                        PomodoroTask(
                            id: UUID(),
                            title: "Task № \($0)",
                            date: Date(),
                            completedInterval: 60 * 5)
                    },
                    onDelete: { _ in })
            }
        }
    }
}
