//
//  TimerService.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 15.11.2022.
//

import Foundation

// MARK: - TimerServiceDelegate

protocol TimerServiceDelegate: AnyObject {
    func timerService(_ service: TimerService, didChangeStateTo state: TimerState)
    func timerService(_ service: TimerService, didTickAtInterval interval: TimeInterval)
    func timerServiceDidFinish(_ service: TimerService)
}

// MARK: - TimerService

protocol TimerService {
    var delegate: TimerServiceDelegate? { get set }
    var currentState: TimerState { get }
    var currentWaitingTime: TimeInterval { get }
    var canBeReseted: Bool { get }
    
    func start(waitingTime: TimeInterval)
    func pause()
    func resume()
    func reset()
}

// MARK: - TimerServiceImpl

final class TimerServiceImpl: TimerService {
    
    // MARK: - Public Properties
    
    weak var delegate: TimerServiceDelegate?
    
    private(set) var currentState: TimerState = .initial {
        didSet {
            delegate?.timerService(self, didChangeStateTo: currentState)
        }
    }
        
    private(set) var currentWaitingTime: TimeInterval = 0.0 {
        didSet {
            delegate?.timerService(self, didTickAtInterval: currentWaitingTime)
        }
    }
    
    var canBeReseted: Bool {
        currentState != .initial && currentState != .paused
    }
    
    // MARK: - Private Properties
    
    private var timer: Timer?
    
    // MARK: - Public Methods
    
    func start(waitingTime: TimeInterval) {
        runTimer(waitingTime: waitingTime)
    }
    
    func pause() {
        currentState = .paused
        timer?.invalidate()
    }
    
    func resume() {
        guard let _ = timer else { return }
        runTimer(waitingTime: currentWaitingTime)
    }
    
    func reset() {
        currentState = .initial
        clearTimer()
    }
    
    // MARK: - Private Methods
    
    private func runTimer(waitingTime: TimeInterval) {
        currentState = .running
        currentWaitingTime = waitingTime
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.currentWaitingTime >= 1.0 {
                self.currentWaitingTime -= 1
            } else {
                self.stop()
                self.delegate?.timerServiceDidFinish(self)
            }
        }
    }
    
    private func stop() {
        currentState = .ended
        clearTimer()
    }
    
    private func clearTimer() {
        timer?.invalidate()
        timer = nil
    }
}
