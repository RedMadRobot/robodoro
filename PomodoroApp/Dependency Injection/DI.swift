//
//  DI.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 15.11.2022.
//

import Foundation

final class DI {
    static var services = AppServices()
    static var workers = AppWorkers(services: services)
}
