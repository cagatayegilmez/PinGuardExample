import Foundation

/// Resolves which `HTTPClient` should execute requests at runtime.
protocol HTTPClientProviding {
    /// Returns the current active client according to runtime settings.
    func makeHTTPClient() -> HTTPClient
}

/// Chooses pinned or plain networking based on persisted settings.
struct SettingsAwareHTTPClientProvider: HTTPClientProviding {
    private let settingsStore: SettingsStore
    private let standardClient: HTTPClient
    private let pinnedClient: HTTPClient

    init(
        settingsStore: SettingsStore,
        standardClient: HTTPClient,
        pinnedClient: HTTPClient
    ) {
        self.settingsStore = settingsStore
        self.standardClient = standardClient
        self.pinnedClient = pinnedClient
    }

    func makeHTTPClient() -> HTTPClient {
        settingsStore.usePinGuard ? pinnedClient : standardClient
    }
}
