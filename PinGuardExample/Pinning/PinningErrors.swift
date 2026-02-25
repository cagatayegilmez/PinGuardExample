import Foundation

/// Errors specific to pinning setup and pin-protected requests.
enum PinningError: Error, LocalizedError, Equatable {
    case invalidHost
    case requestFailed(String)

    var errorDescription: String? {
        switch self {
        case .invalidHost:
            return "Pinned request host is missing or invalid."
        case .requestFailed(let message):
            return "Pinned request failed: \(message)"
        }
    }
}
