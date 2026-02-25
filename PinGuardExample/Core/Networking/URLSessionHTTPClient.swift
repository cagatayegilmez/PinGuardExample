import Foundation

/// `HTTPClient` backed by a plain `URLSession`.
struct URLSessionHTTPClient: HTTPClient {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func execute(_ request: URLRequest) async throws -> HTTPResponse {
        let start = Date()
        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw AppError.network("Server response was not HTTP.")
        }

        let durationMs = Int(Date().timeIntervalSince(start) * 1_000)
        return HTTPResponse(data: data, statusCode: httpResponse.statusCode, durationMilliseconds: durationMs)
    }
}
