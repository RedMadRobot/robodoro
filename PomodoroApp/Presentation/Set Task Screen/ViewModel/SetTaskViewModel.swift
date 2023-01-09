//
//  SetTaskViewModel.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 15.12.2022.
//

import Combine
import SwiftUI

final class SetTaskViewModel: ViewModel {
    
    // MARK: - Constants
    
    private enum Constants {
        static let maxTitleLength = 50
    }
    
    // MARK: - Public Properties
    
    @Published
    var focusTimeValue: TimeInterval {
        didSet {
            performImpactIfNeeded(oldValue: oldValue, newValue: focusTimeValue)
        }
    }
    
    @Published
    var breakTimeValue: TimeInterval {
        didSet {
            performImpactIfNeeded(oldValue: oldValue, newValue: breakTimeValue)
        }
    }
    
    @Published
    var longBreakTimeValue: TimeInterval {
        didSet {
            performImpactIfNeeded(oldValue: oldValue, newValue: longBreakTimeValue)
        }
    }
    
    @Published
    var stagesCount: Int {
        didSet {
            performImpactIfNeeded(oldValue: oldValue, newValue: stagesCount)
        }
    }
    
    @Published
    var taskTitle: String = ""
    
    private(set) var feedbackService: FeedbackService
    
    // MARK: - Private Properties
    
    private let timedPomodoroWorker: TimedPomodoroWorker
    private var userDefaultsStorage: LastUsedValuesStorage
    
    private var trimmedTaskTitle: String {
        taskTitle.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private var isTaskTitleEmptry: Bool {
        trimmedTaskTitle == ""
    }
    
    // MARK: - Init
    
    init(
        timedPomodoroWorker: TimedPomodoroWorker = DI.workers.timedPomodoroWorker,
        userDefaultsStorage: LastUsedValuesStorage = DI.storages.userDefaultsStorage,
        feedbackService: FeedbackService = DI.services.feedbackService
    ) {
        self.timedPomodoroWorker = timedPomodoroWorker
        self.userDefaultsStorage = userDefaultsStorage
        self.feedbackService = feedbackService
        
        self.focusTimeValue = userDefaultsStorage.lastFocusTime
        self.breakTimeValue = userDefaultsStorage.lastBreakTime
        self.longBreakTimeValue = userDefaultsStorage.lastLongBreakTime
        self.stagesCount = userDefaultsStorage.lastStagesCount
    }
    
    // MARK: - Public Methods
    
    func applyParameters() {
        saveLastValues()
        
        let focusTimeValue = focusTimeValue
        let breakTimeValue = breakTimeValue
        let longBreakTimeValue = longBreakTimeValue
        
        timedPomodoroWorker.setup(
            taskName: isTaskTitleEmptry ? nil : trimmedTaskTitle,
            stages: stagesCount,
            intervals: { stage in
                switch stage {
                case .focus:
                    return focusTimeValue
                case .break:
                    return breakTimeValue
                case .longBreak:
                    return longBreakTimeValue
                }
            })
    }
    
    func shouldChangeText(range: NSRange, replacementText: String) -> Bool {
        let currentText = taskTitle
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: replacementText)
        return isValidTitle(title: updatedText)
    }
    
    // MARK: - Private Methods
    
    private func saveLastValues() {
        userDefaultsStorage.lastFocusTime = focusTimeValue
        userDefaultsStorage.lastBreakTime = breakTimeValue
        userDefaultsStorage.lastLongBreakTime = longBreakTimeValue
        userDefaultsStorage.lastStagesCount = stagesCount
    }
    
    private func isValidTitle(title: String) -> Bool {
        !title.contains(where: \.isNewline) && title.count <= Constants.maxTitleLength
    }
}
