import Navidux

public final class NaviduxScreenAssembler: Navidux.ScreenAssembler {
    private var screenFactory: any Navidux.ScreenFactory
    private var alertFactory: Navidux.AlertFactory
    private var screenCoordinator: Navidux.Router?

    public init(
        screenFactory: Navidux.ScreenFactory,
        alertFactory: Navidux.AlertFactory,
        screenCoordinator: Navidux.Router?
    ) {
        self.screenFactory = screenFactory
        self.alertFactory = alertFactory
        self.screenCoordinator = screenCoordinator
    }
    
    public func assemblyScreen(screenType: NaviduxScreen, config: ScreenConfig) -> any NavigationScreen {
        switch screenType {
        case .testScreen:
            return screenFactory.testScreenFactory(screenCoordinator, config)
        default:
            return ViewController(navigation: nil)
        }
    }

    public func assemblyScreen(components: ScreenAsseblyComponents) -> any NavigationScreen {
        assemblyScreen(screenType: components.screenType, config: components.config)
    }
    
    public func assemblyAlert(configuration: AlertConfiguration) -> AlertScreen {
        alertFactory.createAlert(configuration: configuration)
    }
}
