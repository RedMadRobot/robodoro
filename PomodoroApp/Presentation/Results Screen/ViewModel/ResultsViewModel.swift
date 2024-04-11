//
//  ResultsViewModel.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 12.12.2022.
//

import Combine
import Nivelir
import SwiftUI

final class ResultsViewModel: ViewModel {
        
    // MARK: - Private Properties
    
    private let navigator: ScreenNavigator
    private let screens: Screens
    
    private let dateCalculatorService: DateCalculatorService
    private let tasksStorage: TasksStorage
    private var userDefaultsStorage: OnboardingStorage
    
    private var subscriptions = Set<AnyCancellable>()
    
    private var taskToDelete: PomodoroTaskItem?
    
    private let scenarioResolver: ScenarioResolver
    
    // MARK: - Public Properties
    
    @Published
    private(set) var taskItems: [PomodoroTaskItem]
    
    @Published
    private(set) var dailyAverageFocusValue: Double
    
    @Published
    private(set) var totalFocusValue: Double
    
    @Published
    private(set) var showDeletionOnboarding: Bool
    
    @Published
    private(set) var alertState: AlertState = .noAlert
    
    private(set) var feedbackService: FeedbackService
    
    // MARK: - Init
    
    init(
        navigator: ScreenNavigator,
        screens: Screens,
        dateCalculatorService: DateCalculatorService = DI.services.dateCalculatorService,
        tasksStorage: TasksStorage = DI.storages.taskStorage,
        userDefaultsStorage: OnboardingStorage = DI.storages.userDefaultsStorage,
        feedbackService: FeedbackService = DI.services.feedbackService,
        scenarioResolver: ScenarioResolver = ScenarioResolver()
    ) {
        self.navigator = navigator
        self.screens = screens
        self.dateCalculatorService = dateCalculatorService
        self.tasksStorage = tasksStorage
        self.userDefaultsStorage = userDefaultsStorage
        self.feedbackService = feedbackService
        self.scenarioResolver = scenarioResolver
        
        self.showDeletionOnboarding = !userDefaultsStorage.deleteFeatureUsed
        
        let allTasks = tasksStorage.tasks.value
        
        self.taskItems = allTasks.map { PomodoroTaskItem(task: $0) }
        self.dailyAverageFocusValue = dateCalculatorService.calculateCurrentWeekDailyAverageFocusValue(tasks: allTasks)
        self.totalFocusValue = dateCalculatorService.calculateCurrentWeekTotalFocusValue(tasks: allTasks)
        addSubscriptions()
    }
    
    // MARK: - Public Methods
    
    func viewDidAppear() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.showOverlayScreensIfNeeded()
        }
    }
    
    func moveToSettingsTapped() {
        navigator.navigate { route in
            route
                .top(.stack)
                .push(screens.settingsScreen())
        }
    }
    
    func setTaskTapped() {
        let bottomSheet = BottomSheet(
            detents: [.large],
            preferredCard: BottomSheetCard(),
            preferredGrabber: .default,
            prefferedGrabberForMaximumDetentValue: .default
        )
        
        navigator.navigate { route in
            route
                .top(.container)
                .present(
                    screens.setTaskScreen()
                        .withBottomSheetStack(bottomSheet, of: CustomBottomSheetStackController.self)
                )
        }
    }
    
    func prepareToDeleteTask(task: PomodoroTaskItem) {
        taskToDelete = task
        
        let alertViewModel = AlertViewModel(
            title: Strings.ResultsScreen.DeleteTaskAlert.title,
            primaryButtonTitle: Strings.ResultsScreen.DeleteTaskAlert.primaryAction,
            secondaryButtonTitle: Strings.ResultsScreen.DeleteTaskAlert.secondaryAction,
            primaryAction: deleteSelectedTask,
            commonCompletion: { [weak self] in
                self?.taskToDelete = nil
                self?.alertState = .noAlert
            }
        )
        
        alertState = .presenting(alertViewModel)
    }
    
    // MARK: - Private Methods
    
    private func addSubscriptions() {
        tasksStorage.tasks.sink { [weak self] tasks in
            self?.taskItems = tasks.map { PomodoroTaskItem(task: $0) }
            self?.recalculateTime(tasks: tasks)
        }
        .store(in: &subscriptions)
    }
    
    private func recalculateTime(tasks: [PomodoroTask]) {
        dailyAverageFocusValue = dateCalculatorService.calculateCurrentWeekDailyAverageFocusValue(tasks: tasks)
        totalFocusValue = dateCalculatorService.calculateCurrentWeekTotalFocusValue(tasks: tasks)
    }
    
    private func deleteSelectedTask() {
        guard let taskToDelete else { return }
        tasksStorage.deleteTask(withId: taskToDelete.id)
        userDefaultsStorage.deleteFeatureUsed = true
        showDeletionOnboarding = false
    }
    
    private func showOverlayScreensIfNeeded() {
        guard !showOnboardingIfNeeded() else { return }
        guard !showPreviousResultsScreenIfNeeded() else { return }
        guard !showPomodoroScreenIfNeeded() else { return }
    }
    
    private func showOnboardingIfNeeded() -> Bool {
        if scenarioResolver.shouldShowOnboarding {
            navigator.navigate { route in
                route
                    .top(.container)
                    .present(
                        screens.onboardingScreen(
                            delegate: self
                        )
                        .withModalPresentationStyle(.overFullScreen)
                        .withModalTransitionStyle(.crossDissolve)
                    )
            }
            return true
        }
        return false
    }
    
    private func showPreviousResultsScreenIfNeeded() -> Bool {
        if scenarioResolver.shouldShowPreviousResults {
            let bottomSheet = BottomSheet(
                detents: [.large],
                preferredCard: BottomSheetCard(),
                preferredGrabber: .default,
                prefferedGrabberForMaximumDetentValue: .default
            )
            navigator.navigate { route in
                route
                    .top(.container)
                    .present(
                        screens.previousResultsScreen()
                            .withBottomSheetStack(bottomSheet, of: CustomBottomSheetStackController.self)
                    )
            }
            return true
        }
        return false
    }
    
    private func showPomodoroScreenIfNeeded() -> Bool {
        guard scenarioResolver.shouldShowPomodoro else { return false }
        navigator.navigate { route in
            route
                .top(.container)
                .present(
                    screens.pomodoroScreen()
                        .withStackContainer(of: CustomStackController.self)
                        .withModalPresentationStyle(.fullScreen)
                )
        }
        return true
    }
}

// MARK: - OnboardingScreenDelegate

extension ResultsViewModel: OnboardingScreenDelegate {
    func onboardingCompleted() {
        showOverlayScreensIfNeeded()
    }
}
