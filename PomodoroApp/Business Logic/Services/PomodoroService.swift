//
//  PomodoroService.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 15.11.2022.
//

import Foundation

// MARK: - PomodoroServiceDelegate

protocol PomodoroServiceDelegate: AnyObject {
    func pomodoroService(_ service: PomodoroService, didChangeStateTo state: PomodoroState)
    func pomodoroServiceEnded(_ service: PomodoroService)
}

// MARK: - PomodoroService

protocol PomodoroService {
    var delegate: PomodoroServiceDelegate? { get set }
    var currentState: PomodoroState { get }
    var stagesCount: Int { get }
    var completedStages: Int { get }
    var atLastStateOfCurrentStage: Bool { get }
    var atLastState: Bool { get }
    var dataToSave: PomodoroServiceSavedData { get }
    
    func setup(stages: Int)
    func setup(savedData: PomodoroServiceSavedData)
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
    
    var atLastState: Bool {
        innerIndex == pomodoroCycle[outerIndex].count - 1 && outerIndex == pomodoroCycle.count - 1
    }
    
    var dataToSave: PomodoroServiceSavedData {
        PomodoroServiceSavedData(
            stagesCount: stagesCount,
            innerIndex: innerIndex,
            outerIndex: outerIndex)
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
            guard !ignoreDelegate else { return }
            delegate?.pomodoroService(self, didChangeStateTo: currentState)
        }
    }
    private var outerIndex: Int = 0 {
        didSet {
            innerIndex = 0
        }
    }
    
    // TODO: - Понять зачем
    private var ignoreDelegate = false
    
    // MARK: - Public Methods
    
    func setup(stages: Int) {
        pomodoroCycle = generatePomodoroCycle(stages: stages)
    }
    
    func setup(savedData: PomodoroServiceSavedData) {
        ignoreDelegate = true
        pomodoroCycle = generatePomodoroCycle(stages: savedData.stagesCount)
        outerIndex = savedData.outerIndex
        innerIndex = savedData.innerIndex
        ignoreDelegate = false
        delegate?.pomodoroService(self, didChangeStateTo: currentState)
    }
    
    func moveForward() {
        if innerIndex < pomodoroCycle[outerIndex].count - 1 {
            innerIndex += 1
        } else if outerIndex < pomodoroCycle.count - 1 {
            outerIndex += 1
        } else {
            delegate?.pomodoroServiceEnded(self)
        }
    }
    
    func reset() {
        outerIndex = 0
    }
    
    // MARK: - Private Methods
    
    func generatePomodoroCycle(stages: Int) -> [[PomodoroState]] {
        var cycle: [[PomodoroState]] = []
        for _ in 0..<(stages - 1) {
            cycle.append([.focus, .break])
        }
        cycle.append([.focus, .longBreak])
        return cycle
    }
}
