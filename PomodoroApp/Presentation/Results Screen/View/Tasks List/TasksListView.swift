//
//  TasksListView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 20.12.2022.
//

import SwiftUI

struct TasksListView: View {
    
    // MARK: - Private Properties
    
    @Binding
    private var tasks: [PomodoroTask]
    
    private var onDelete: (PomodoroTask) -> Void
    
    // MARK: - Init
    
    init(
        tasks: Binding<[PomodoroTask]>,
        onDelete: @escaping (PomodoroTask) -> Void
    ) {
        self._tasks = tasks
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
        .font(.miniTitle)
        .foregroundColor(Color(Colors.textGray2))
    }
    
    @ViewBuilder
    private var tableView: some View {
        ForEach(tasks, id: \.id) { task in
            TaskView(
                task: task,
                onDelete: {
                    onDelete(task)
                }
            )
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
}

// MARK: - PreviewProvider

struct TasksListView_Previews: PreviewProvider {
    
    struct BindingValueHolder: View {
        
        @State var tasks: [PomodoroTask] = Array(1...10).map {
            PomodoroTask(
                id: UUID(),
                title: "Task № \($0)",
                date: Date(),
                completedInterval: 60 * 5)
        }
        
        var body: some View {
            TasksListView(
                tasks: $tasks,
                onDelete: { _ in })
        }
    }
    
    static var previews: some View {
        ZStack {
            Color(Colors.gray)
                .ignoresSafeArea()
            ScrollView {
                BindingValueHolder()
            }
        }
    }
}
