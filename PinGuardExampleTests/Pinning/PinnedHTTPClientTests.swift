@testable import PinGuardExample
import XCTest

final class PinnedHTTPClientTests: XCTestCase {
    func testPinnedHTTPClientForwardsNonPinnedHostToWrappedClient() async throws {
        let wrapped = MockHTTPClient()
        wrapped.result = .success(
            HTTPResponse(data: Data(), statusCode: 204, durationMilliseconds: 1)
        )
        let provider = MockPinGuardConfigurationProvider(host: "api.cagatayegilmez.com")
        let session = MockPinGuardSession(response: .failure(URLError(.badURL)))
        let sessionBuilder = MockPinGuardSessionBuilder(session: session)
        let sut = PinnedHTTPClient(
            wrapped: wrapped,
            configurationProvider: provider,
            sessionBuilder: sessionBuilder
        )

        let request = URLRequest(url: URL(string: "https://example.org")!)
        _ = try await sut.execute(request)

        XCTAssertEqual(wrapped.executedRequests.count, 1)
        XCTAssertEqual(sessionBuilder.makeSessionCallCount, 0)
    }
}
