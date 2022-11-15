//
//  TimerService.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 15.11.2022.
//

import Foundation

final class TimerService {
    
//    // MARK: - Public Properties
//
//    var isRepeatable: Bool = true
//    var interval: Double = 0.0
//
//    // MARK: - Private Properties
//
//    private var timer: Timer? = Timer()
//    private var callback: () -> Void
//
//    private var startTime: TimeInterval?
//    private var elapsedTime: TimeInterval?
//
//    // MARK: - Init
//
//    init(
//        interval: Double,
//        isRepeatable: Bool,
//        callback: @escaping () -> Void
//    ) {
//        self.interval = interval
//        self.callback = callback
//        self.isRepeatable = isRepeatable
//    }
//
//    // MARK: - Public Methods
//
//    func isPaused() -> Bool {
//        guard let timer = timer else { return false }
//        return !timer.isValid
//    }
//
//    func start() {
//        runTimer(interval: interval)
//    }
//
//    func pause() {
//        elapsedTime = Date.timeIntervalSinceReferenceDate - (startTime ?? 0.0)
//        timer?.invalidate()
//    }
//
//    func resume() {
//        if !isRepeatable {
//            interval -= elapsedTime ?? 0.0
//        }
//        runTimer(interval: interval)
//    }
//
//    func invalidate() {
//        timer?.invalidate()
//    }
//
//    func reset() {
//        timer?.invalidate()
//        runTimer(interval: interval)
//    }
//
//    // MARK: Private
//
//    private func runTimer(interval: Double) {
//        startTime = Date.timeIntervalSinceReferenceDate
//
//        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: isRepeatable) { [weak self] _ in
//            self?.callback()
//        }
//    }
}
