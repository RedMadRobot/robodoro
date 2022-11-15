//
//  PomodoroService.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 15.11.2022.
//

import Foundation

protocol PomodoroServiceDelegate: AnyObject {
    func pomododoService(_ service: PomodoroService, didChangeStateTo state: PomodoroState)
}

final class PomodoroService {
    
    // MARK: - Public Properties
    
    weak var delegate: PomodoroServiceDelegate?
    
    var currentState: PomodoroState {
        pomodoroCycle[outerIndex][innerIndex]
    }
    
    var atInitialState: Bool {
        innerIndex == 0 && outerIndex == 0
    }
    
    var stagesCount: Int {
        pomodoroCycle.count - 1
    }
    
    var completedStages: Int {
        outerIndex
    }
    
    // MARK: - Private Properties
    
    private let pomodoroCycle: [[PomodoroState]] = [
        [.focus, .break],
        [.focus, .break],
        [.focus, .break],
        [.focus],
        [.longBreak]
    ]
    private var innerIndex: Int = 0
    private var outerIndex: Int = 0 {
        didSet {
            innerIndex = 0
        }
    }
    
    // MARK: - Public Methods
    
    func moveForward() {
        if innerIndex < pomodoroCycle[outerIndex].count - 1 {
            innerIndex += 1
        } else if outerIndex < pomodoroCycle.count - 1 {
             outerIndex += 1
        } else {
            return reset()
        }
        delegate?.pomododoService(self, didChangeStateTo: currentState)
    }
    
    func reset() {
        outerIndex = 0
        delegate?.pomododoService(self, didChangeStateTo: currentState)
    }
}
