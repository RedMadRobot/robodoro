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
    
    func start()
    func pause()
    func resume()
    func reset(waitingTime: TimeInterval)
    func stop()
    func suspend()
}

// MARK: - TimerServiceImpl

final class TimerServiceImpl: TimerService {
    
    // MARK: - Public Properties
    
    weak var delegate: TimerServiceDelegate?
    
    private(set) var currentState: TimerState = .initial(0) {
        didSet {
            delegate?.timerService(self, didChangeStateTo: currentState)
        }
    }
        
    private(set) var currentWaitingTime: TimeInterval = 0 {
        didSet {
            delegate?.timerService(self, didTickAtInterval: currentWaitingTime)
        }
    }
        
    // MARK: - Private Properties
    
    private var timer: Timer?
    
    // MARK: - Public Methods
    
    func start() {
        runTimer()
    }
    
    func pause() {
        currentState = .paused(currentWaitingTime)
        timer?.invalidate()
    }
    
    func resume() {
        guard let _ = timer else { return }
        runTimer()
    }
    
    func reset(waitingTime: TimeInterval) {
        currentWaitingTime = waitingTime
        currentState = .initial(currentWaitingTime)
        clearTimer()
    }
    
    func stop() {
        currentState = .ended
        clearTimer()
    }
    
    func suspend() {
        timer?.invalidate()
    }
    
    // MARK: - Private Methods
    
    private func runTimer() {
        currentState = .running
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            if self.currentWaitingTime >= 1.0 {
                self.currentWaitingTime -= 1
            } else {
                self.stop()
                self.delegate?.timerServiceDidFinish(self)
            }
        }
        RunLoop.main.add(timer, forMode: .common)
        self.timer = timer
    }
    
    private func clearTimer() {
        timer?.invalidate()
        timer = nil
    }
}
