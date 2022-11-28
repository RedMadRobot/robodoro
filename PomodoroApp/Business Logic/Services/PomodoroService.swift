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
    var atInitialState: Bool { get }
    var stagesCount: Int { get }
    var completedStages: Int { get }
    var leftIntervals: [TimeInterval] { get }
    
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
    
    var atInitialState: Bool {
        innerIndex == 0 && outerIndex == 0
    }
    
    var stagesCount: Int {
        pomodoroCycle.count - 1
    }
    
    var completedStages: Int {
        outerIndex
    }
    
    var leftIntervals: [TimeInterval] {
        var intervals: [TimeInterval] = []
        for inner in innerIndex..<pomodoroCycle[outerIndex].count {
            intervals.append(pomodoroCycle[outerIndex][inner].waitingTime)
        }
        
        for outer in (outerIndex + 1)..<pomodoroCycle.count {
            for inner in 0..<pomodoroCycle[outer].count {
                intervals.append(pomodoroCycle[outer][inner].waitingTime)
            }
        }
        
        return intervals
    }
        
    // MARK: - Private Properties
    
    private let pomodoroCycle: [[PomodoroState]] = [
        [.focus, .break],
        [.focus, .break],
        [.focus, .break],
        [.focus],
        [.longBreak]
    ]
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
