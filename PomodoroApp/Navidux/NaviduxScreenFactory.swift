import Navidux

extension Navidux.ScreenFactory {
    var testScreenFactory: (Router?, ScreenConfig) -> any NavigationScreen {
        { coordinator, screenConfig in
            TestViewController(
                title: screenConfig.navigationTitle,
                isNeedBackButton: screenConfig.isNeedSetBackButton,
                navigation: coordinator,
                output: screenConfig.output
            )
        }
    }
}

final class NaviduxScreenFactory: Navidux.ScreenFactory {
    init() {}
}
