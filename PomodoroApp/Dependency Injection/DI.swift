//
//  DI.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 15.11.2022.
//

import Foundation

final class DI {
    static var services = AppServices(storages: storages)
    static var storages = AppStorages()
    static var workers = AppWorkers(services: services, storages: storages)
}
