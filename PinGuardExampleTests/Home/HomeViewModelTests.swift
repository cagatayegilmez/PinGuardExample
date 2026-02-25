@testable import PinGuardExample
import XCTest

@MainActor
final class HomeViewModelTests: XCTestCase {
    func testHomeViewModelSuccessState() async {
        let payload = #"{"ok":true}"#.data(using: .utf8)!
        let response = HTTPResponse(data: payload, statusCode: 200, durationMilliseconds: 42)
        let mockClient = MockHTTPClient()
        mockClient.result = .success(response)

        let provider = MockHTTPClientProvider(client: mockClient)
        let viewModel = HomeViewModel(
            apiConfiguration: APIConfiguration(testPath: "/"),
            httpClientProvider: provider,
            pinConfigurationProvider: MockPinGuardConfigurationProvider(),
            onOpenSettings: {}
        )

        await viewModel.testConnection()

        XCTAssertEqual(viewModel.status, .success)
        XCTAssertEqual(viewModel.statusCode, 200)
        XCTAssertEqual(viewModel.durationMilliseconds, 42)
        XCTAssertTrue(viewModel.responseBody.contains("\"ok\""))
    }

    func testHomeViewModelFailureStateForNetworkError() async {
        let mockClient = MockHTTPClient()
        mockClient.result = .failure(URLError(.notConnectedToInternet))

        let provider = MockHTTPClientProvider(client: mockClient)
        let viewModel = HomeViewModel(
            apiConfiguration: APIConfiguration(testPath: "/"),
            httpClientProvider: provider,
            pinConfigurationProvider: MockPinGuardConfigurationProvider(),
            onOpenSettings: {}
        )

        await viewModel.testConnection()

        XCTAssertEqual(viewModel.status, .failure)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.errorMessage?.contains("Network error") == true)
    }

    func testToggleUsePinGuardChangesWhichClientIsUsed() {
        let settings = InMemorySettingsStore(usePinGuard: true)
        let standardClient = MockHTTPClient()
        let pinnedClient = MockHTTPClient()
        let provider = SettingsAwareHTTPClientProvider(
            settingsStore: settings,
            standardClient: standardClient,
            pinnedClient: pinnedClient
        )

        let whenEnabled = provider.makeHTTPClient()
        settings.usePinGuard = false
        let whenDisabled = provider.makeHTTPClient()

        XCTAssertTrue((whenEnabled as AnyObject) === (pinnedClient as AnyObject))
        XCTAssertTrue((whenDisabled as AnyObject) === (standardClient as AnyObject))
    }

    func testBackupPinOnlyModeChangesProvidedPinsList() {
        let settings = InMemorySettingsStore(usePinGuard: true, useBackupPinOnly: false)
        let provider = DefaultPinGuardConfigurationProvider(settingsStore: settings)

        XCTAssertEqual(provider.currentConfiguration().pins.count, 2)

        settings.useBackupPinOnly = true
        XCTAssertEqual(provider.currentConfiguration().pins, [Secrets.backupSPKIPin])
    }
}
