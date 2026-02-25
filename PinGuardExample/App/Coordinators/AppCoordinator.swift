import SwiftUI
import UIKit

/// Root coordinator that owns app-level navigation.
final class AppCoordinator: Coordinator {
    private let window: UIWindow
    private let navigationController: UINavigationController
    private let container: AppContainer
    private var homeViewModel: HomeViewModel?

    init(window: UIWindow, container: AppContainer) {
        self.window = window
        self.container = container
        self.navigationController = UINavigationController()
    }

    func start() {
        let homeViewModel = HomeViewModel(
            apiConfiguration: container.apiConfiguration,
            httpClientProvider: container.httpClientProvider,
            pinConfigurationProvider: container.pinConfigurationProvider,
            onOpenSettings: { [weak self] in
                self?.showSettings()
            }
        )

        let homeView = HomeView(viewModel: homeViewModel)
        let homeHost = UIHostingController(rootView: homeView)
        navigationController.viewControllers = [homeHost]
        self.homeViewModel = homeViewModel

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    private func showSettings() {
        let settingsViewModel = SettingsViewModel(settingsStore: container.settingsStore) { [weak self] in
            self?.navigationController.popViewController(animated: true)
            self?.homeViewModel?.refreshPinDiagnostics()
        }

        let settingsView = SettingsView(viewModel: settingsViewModel)
        let settingsHost = UIHostingController(rootView: settingsView)
        navigationController.pushViewController(settingsHost, animated: true)
    }
}
