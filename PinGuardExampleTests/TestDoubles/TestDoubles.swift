@testable import PinGuardExample
import Foundation
import PinGuard

final class MockHTTPClient: HTTPClient {
    var result: Result<HTTPResponse, Error> = .failure(URLError(.badServerResponse))
    private(set) var executedRequests: [URLRequest] = []

    func execute(_ request: URLRequest) async throws -> HTTPResponse {
        executedRequests.append(request)
        return try result.get()
    }
}

final class MockHTTPClientProvider: HTTPClientProviding {
    var client: HTTPClient

    init(client: HTTPClient) {
        self.client = client
    }

    func makeHTTPClient() -> HTTPClient {
        client
    }
}

final class InMemorySettingsStore: SettingsStore {
    var usePinGuard: Bool
    var useBackupPinOnly: Bool

    init(usePinGuard: Bool = true, useBackupPinOnly: Bool = false) {
        self.usePinGuard = usePinGuard
        self.useBackupPinOnly = useBackupPinOnly
    }
}

struct MockPinGuardConfigurationProvider: PinGuardConfigurationProviding {
    var host: String = "api.cagatayegilmez.com"
    var pins: [String] = [Secrets.primarySPKIPin, Secrets.backupSPKIPin]

    func currentConfiguration() -> PinningTargetConfiguration {
        PinningTargetConfiguration(host: host, pins: pins)
    }

    func makePolicySet() -> PolicySet {
        let policy = PinningPolicy(
            pins: [
                Pin(type: .spki, hash: pins.first ?? "", role: .primary, scope: .leaf)
            ]
        )
        return PolicySet(policies: [HostPolicy(pattern: .exact(host), policy: policy)])
    }

    func maskedPinsForDisplay() -> [String] {
        pins.map { "\($0.prefix(6))..." }
    }
}

final class MockPinGuardSession: PinGuardSessioning {
    var response: Result<(Data, URLResponse), Error>

    init(response: Result<(Data, URLResponse), Error>) {
        self.response = response
    }

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try response.get()
    }
}

final class MockPinGuardSessionBuilder: PinGuardSessionBuilding {
    var session: PinGuardSessioning
    private(set) var makeSessionCallCount = 0

    init(session: PinGuardSessioning) {
        self.session = session
    }

    func makeSession() -> PinGuardSessioning {
        makeSessionCallCount += 1
        return session
    }
}
