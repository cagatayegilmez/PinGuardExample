import Foundation

/// Minimal networking abstraction used by feature layers.
protocol HTTPClient {
    /// Executes the provided request and returns a normalized response model.
    func execute(_ request: URLRequest) async throws -> HTTPResponse
}

/// Canonical response model used across app layers.
struct HTTPResponse: Sendable {
    /// Raw payload returned by the server.
    let data: Data
    /// HTTP status code.
    let statusCode: Int
    /// Request duration in milliseconds.
    let durationMilliseconds: Int
}
