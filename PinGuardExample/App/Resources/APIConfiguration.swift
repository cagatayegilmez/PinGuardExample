import Foundation

/// Centralized API endpoint configuration for the app.
struct APIConfiguration {
    /// Base URL used by all remote requests.
    let baseURL: URL
    /// Relative path used by the "Test Connection" flow.
    let testPath: String

    init(
        baseURL: URL = URL(string: "https://api.cagatayegilmez.com")!,
        testPath: String = "/health"
    ) {
        self.baseURL = baseURL
        self.testPath = testPath
    }

    /// Builds the URLRequest used by the Home screen test action.
    func makeTestRequest() throws -> URLRequest {
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
            throw AppError.network("Could not create URL components.")
        }

        let normalizedPath: String
        if testPath.isEmpty {
            normalizedPath = "/"
        } else if testPath.hasPrefix("/") {
            normalizedPath = testPath
        } else {
            normalizedPath = "/\(testPath)"
        }

        components.path = normalizedPath

        guard let finalURL = components.url else {
            throw AppError.network("Could not build request URL.")
        }

        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}
