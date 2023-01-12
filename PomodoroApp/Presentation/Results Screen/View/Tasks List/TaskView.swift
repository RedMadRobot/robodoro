//
//  TaskView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 20.12.2022.
//

import SwiftUI
import SwipeActions

struct TaskView: View {
    
    // MARK: - Private Properties
    
    @Binding
    private var swipeState: SwipeState
    
    private let task: PomodoroTask
    
    private var onDelete: () -> Void
    
    private let formatter: DateFormatter = .onlyDateFormatter
    
    // MARK: - Init
    
    init(
        task: PomodoroTask,
        swipeState: Binding<SwipeState>,
        onDelete: @escaping () -> Void
    ) {
        self.task = task
        self._swipeState = swipeState
        self.onDelete = onDelete
    }
    
    // MARK: - View
    
    var body: some View {
        frontView
            .addSwipeAction(edge: .trailing, state: $swipeState) {
                Button {
                    onDelete()
                } label: {
                    Image(uiImage: Images.trash)
                }
                .frame(width: 54, height: 14, alignment: .center)
            }
            .onTapGesture {
                swipeState = .swiped(UUID())
            }
            .mask(LinearGradient(gradient: Gradient(stops: [
                .init(color: .clear, location: 0),
                .init(color: .black, location: 0.05),
            ]), startPoint: .leading, endPoint: .trailing))
            .contentShape(Rectangle())
    }
    
    // MARK: - Private Properties
    
    @ViewBuilder
    private var frontView: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title ?? "Noname Task")
                Text(formatter.string(from: task.date))
                    .foregroundColor(Color(Colors.textGray2))
            }
            .font(.miniTitle)
            Spacer()
            Text("\(task.completedInterval.minutesIgnoringHours)")
                .font(.miniTime)
                .contentShape(Rectangle())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
    }
}

// MARK: - PreviewProvider

struct TaskView_Previews: PreviewProvider {
    
    struct BindingValueHolder: View {
        
        @State var value: SwipeState = .untouched
        
        var body: some View {
            TaskView(
                task: .init(
                    id: UUID(),
                    title: nil,
                    date: Date(),
                    completedInterval: 60 * 60 * 10),
                swipeState: $value,
                onDelete: {})
        }
    }
    
    static var previews: some View {
        BindingValueHolder()
    }
}
