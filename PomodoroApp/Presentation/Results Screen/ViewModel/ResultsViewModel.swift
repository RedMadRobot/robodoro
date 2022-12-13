//
//  ResultsViewModel.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 12.12.2022.
//

import Combine
import SwiftUI

final class ResultsViewModel: ObservableObject {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    private let timedPomodoroWorker: TimedPomodoroWorker
    
    // MARK: - Init
    
    init(timedPomodoroWorker: TimedPomodoroWorker = DI.workers.timedPomodoroWorker) {
        self.timedPomodoroWorker = timedPomodoroWorker
    }
    
    // MARK: - Public Methods
    
    func prepareToStartPomodoro() {
        timedPomodoroWorker.setup(
            stages: 10,
            intervals: { stage in
                switch stage {
                case .focus:
                    return 10
                case .break:
                    return 5
                case .longBreak:
                    return 10
                }
            })
    }
    
    // MARK: - Private Methods
    
}
