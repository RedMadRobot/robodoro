//
//  PomodoroService.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 15.11.2022.
//

import Foundation

// MARK: - PomodoroServiceDelegate

protocol PomodoroServiceDelegate: AnyObject {
    func pomododoService(_ service: PomodoroService, didChangeStateTo state: PomodoroState)
}

// MARK: - PomodoroService

protocol PomodoroService {
    var delegate: PomodoroServiceDelegate? { get set }
    var currentState: PomodoroState { get }
    var stagesCount: Int { get }
    var completedStages: Int { get }
    var atLastStateOfCurrentStage: Bool { get }
    
    func setup(stages: Int)
    func moveForward()
    func reset()
}

// MARK: - PomodoroService

final class PomodoroServiceImpl: PomodoroService {
    
    // MARK: - Public Properties
    
    weak var delegate: PomodoroServiceDelegate?
    
    var currentState: PomodoroState {
        pomodoroCycle[outerIndex][innerIndex]
    }
    
    var stagesCount: Int {
        pomodoroCycle.count
    }
    
    var completedStages: Int {
        outerIndex
    }
     
    var atLastStateOfCurrentStage: Bool {
        innerIndex == pomodoroCycle[outerIndex].count - 1
    }
    
    // MARK: - Private Properties
    
    private var pomodoroCycle: [[PomodoroState]] = [
        [.focus, .break],
        [.focus, .break],
        [.focus, .break],
        [.focus, .longBreak]
    ] {
        didSet {
            reset()
        }
    }
    
    private var innerIndex: Int = 0 {
        didSet {
            delegate?.pomododoService(self, didChangeStateTo: currentState)
        }
    }
    private var outerIndex: Int = 0 {
        didSet {
            innerIndex = 0
        }
    }
    
    // MARK: - Public Methods
    
    func setup(stages: Int) {
        var newPomodoroCycle: [[PomodoroState]] = []
        for _ in 0..<(stages - 1) {
            newPomodoroCycle.append([.focus, .break])
        }
        newPomodoroCycle.append([.focus, .longBreak])
        pomodoroCycle = newPomodoroCycle
    }
    
    func moveForward() {
        if innerIndex < pomodoroCycle[outerIndex].count - 1 {
            innerIndex += 1
        } else if outerIndex < pomodoroCycle.count - 1 {
            outerIndex += 1
        }
    }
    
    func reset() {
        outerIndex = 0
    }
}
