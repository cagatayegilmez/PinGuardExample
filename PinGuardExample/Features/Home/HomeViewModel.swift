import Foundation
import Observation

/// UI states for the Home screen request lifecycle.
enum HomeRequestStatus: String {
    case idle
    case loading
    case success
    case failure
}

/// View model for the Home feature.
@MainActor
@Observable
final class HomeViewModel {
    private(set) var status: HomeRequestStatus = .idle
    private(set) var responseBody: String = "No response yet."
    private(set) var statusCode: Int?
    private(set) var durationMilliseconds: Int?
    private(set) var errorMessage: String?
    private(set) var pinnedHost: String = ""
    private(set) var activePinMasks: [String] = []

    private let apiConfiguration: APIConfiguration
    private let httpClientProvider: HTTPClientProviding
    private let pinConfigurationProvider: PinGuardConfigurationProviding
    private let onOpenSettings: () -> Void

    init(
        apiConfiguration: APIConfiguration,
        httpClientProvider: HTTPClientProviding,
        pinConfigurationProvider: PinGuardConfigurationProviding,
        onOpenSettings: @escaping () -> Void
    ) {
        self.apiConfiguration = apiConfiguration
        self.httpClientProvider = httpClientProvider
        self.pinConfigurationProvider = pinConfigurationProvider
        self.onOpenSettings = onOpenSettings
        refreshPinDiagnostics()
    }

    /// Handles tap on settings navigation action.
    func didTapSettings() {
        onOpenSettings()
    }

    /// Reloads host + masked pin diagnostics for the active setting state.
    func refreshPinDiagnostics() {
        let config = pinConfigurationProvider.currentConfiguration()
        pinnedHost = config.host
        activePinMasks = pinConfigurationProvider.maskedPinsForDisplay()
    }

    /// Executes the test API call and maps results into display state.
    func testConnection() async {
        status = .loading
        statusCode = nil
        durationMilliseconds = nil
        errorMessage = nil

        do {
            let request = try apiConfiguration.makeTestRequest()
            let client = httpClientProvider.makeHTTPClient()
            let response = try await client.execute(request)

            status = .success
            statusCode = response.statusCode
            durationMilliseconds = response.durationMilliseconds
            responseBody = JSONPrettyPrinter.stringify(response.data)
        } catch {
            status = .failure
            let appError = AppError.map(error)
            errorMessage = appError.localizedDescription
            responseBody = "Request failed."
        }

        refreshPinDiagnostics()
    }
}
