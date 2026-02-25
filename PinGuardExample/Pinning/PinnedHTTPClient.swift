import Foundation
import PinGuard

/// Adapter protocol used to test `PinnedHTTPClient` without real network calls.
protocol PinGuardSessioning {
    /// Executes a request through a PinGuard-managed URLSession.
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension PinGuardSession: PinGuardSessioning {}

/// Factory abstraction for creating PinGuard sessions.
protocol PinGuardSessionBuilding {
    /// Creates a new pin-validated session instance.
    func makeSession() -> PinGuardSessioning
}

/// Default PinGuard session factory.
struct PinGuardSessionBuilder: PinGuardSessionBuilding {
    func makeSession() -> PinGuardSessioning {
        PinGuardSession(configuration: .ephemeral, pinGuard: .shared)
    }
}

/// Decorator that applies PinGuard for requests targeting the pinned host.
struct PinnedHTTPClient: HTTPClient {
    private let wrapped: HTTPClient
    private let configurationProvider: PinGuardConfigurationProviding
    private let sessionBuilder: PinGuardSessionBuilding

    init(
        wrapped: HTTPClient,
        configurationProvider: PinGuardConfigurationProviding,
        sessionBuilder: PinGuardSessionBuilding = PinGuardSessionBuilder()
    ) {
        self.wrapped = wrapped
        self.configurationProvider = configurationProvider
        self.sessionBuilder = sessionBuilder
    }

    func execute(_ request: URLRequest) async throws -> HTTPResponse {
        guard let requestHost = request.url?.host else {
            throw PinningError.invalidHost
        }

        let activeConfiguration = configurationProvider.currentConfiguration()
        guard requestHost == activeConfiguration.host else {
            return try await wrapped.execute(request)
        }

        configurePinGuard(policySet: configurationProvider.makePolicySet())

        let start = Date()
        do {
            let session = sessionBuilder.makeSession()
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw AppError.network("Server response was not HTTP.")
            }

            let duration = Int(Date().timeIntervalSince(start) * 1_000)
            return HTTPResponse(data: data, statusCode: httpResponse.statusCode, durationMilliseconds: duration)
        } catch {
            throw PinningError.requestFailed(error.localizedDescription)
        }
    }

    /// Applies host policy to the shared PinGuard runtime.
    private func configurePinGuard(policySet: PolicySet) {
        PinGuard.configure { builder in
            builder.environment(.prod, policySet: policySet)
            builder.selectEnvironment(.prod)
        }
    }
}
