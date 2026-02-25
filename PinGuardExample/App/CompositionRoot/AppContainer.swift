import Foundation

/// Composition root for dependency injection.
final class AppContainer {
    let apiConfiguration: APIConfiguration
    let settingsStore: SettingsStore
    let pinConfigurationProvider: PinGuardConfigurationProviding
    let httpClientProvider: HTTPClientProviding

    init() {
        let settingsStore = UserDefaultsSettingsStore()
        let pinConfigurationProvider = DefaultPinGuardConfigurationProvider(settingsStore: settingsStore)

        let plainClient = URLSessionHTTPClient()
        let pinnedClient = PinnedHTTPClient(
            wrapped: plainClient,
            configurationProvider: pinConfigurationProvider
        )

        self.apiConfiguration = APIConfiguration()
        self.settingsStore = settingsStore
        self.pinConfigurationProvider = pinConfigurationProvider
        self.httpClientProvider = SettingsAwareHTTPClientProvider(
            settingsStore: settingsStore,
            standardClient: plainClient,
            pinnedClient: pinnedClient
        )
    }
}
