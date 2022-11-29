//
//  FeedbackService.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 29.11.2022.
//

import CoreHaptics

// MARK: - FeedbackService

protocol FeedbackService {
    func playTimerEndSignal()
}

// MARK: - FeedbackServiceImpl

final class FeedbackServiceImpl: FeedbackService {
    
    // MARK: - Private Properties
    
    private var engine: CHHapticEngine?
    
    // Альтернативный паттерн
    private var sosEvents: [CHHapticEvent] {
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        return [
            CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0),
            CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0.2),
            CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0.4),
            CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0.6, duration: 0.5),
            CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 1.2, duration: 0.5),
            CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 1.8, duration: 0.5),
            CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 2.4),
            CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 2.6),
            CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 2.8)
        ]
    }
    
    private var continiousEvents: [CHHapticEvent] {
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        return [
            CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0, duration: 2),
        ]
    }
    
    // MARK: - Init
    
    init() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        }
        catch {
            print("Error: ", error)
        }
    }
    
    // MARK: - Public Methods
    
    func playTimerEndSignal() {
        do {
            try engine?.start()
            let pattern = try CHHapticPattern(events: continiousEvents, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Error: ", error)
        }
    }
}
