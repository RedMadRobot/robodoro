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
    private var editingTask: PomodoroTaskItem?
    
    private let tasks: [PomodoroTaskItem]
    
    private var onDelete: ((PomodoroTaskItem) -> Void)?
    
    // MARK: - Init
    
    init(
        tasks: [PomodoroTaskItem],
        onDelete: ((PomodoroTaskItem) -> Void)? = nil
    ) {
        self.tasks = tasks
        self.onDelete = onDelete
    }
    
    // MARK: - View
    
    var body: some View {
        VStack(spacing: 0) {
            titleView
            tableView
        }
        .background(
            RoundedRectangle(cornerRadius: 32)
                .fill(Colors.white.swiftUIColor))
        .animation(.easeInOut, value: tasks)
    }
    
    // MARK: - Private Properties
    
    @ViewBuilder
    private var titleView: some View {
        HStack {
            Text(Strings.TasksList.tasksColumnTitle)
                .textStyle(.regularText, color: Colors.textGray2.swiftUIColor)
            Spacer()
            Text(Strings.TasksList.timeColumnTitle)
                .textStyle(.regularText, color: Colors.textGray2.swiftUIColor)
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
    }
    
    @ViewBuilder
    private var tableView: some View {
        LazyVStack(spacing: 0) {
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
    }
    
    @ViewBuilder
    private var divider: some View {
        Divider()
            .overlay(Colors.textGray2.swiftUIColor)
            .padding(.horizontal, 16)
    }
    
    // MARK: - Private Methods
    
    private func onRowTapped(task: PomodoroTaskItem) {
        guard onDelete != nil else { return }
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
            Colors.gray.swiftUIColor
                .ignoresSafeArea()
            ScrollView {
                TasksListView(
                    tasks: Array(1...10).map {
                        PomodoroTaskItem(task: .init(
                            id: UUID(),
                            title: "Task № \($0)",
                            date: Date(),
                            completedInterval: 60 * 5))
                    },
                    onDelete: { _ in })
            }
        }
    }
}
