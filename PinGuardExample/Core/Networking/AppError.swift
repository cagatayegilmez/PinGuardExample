import Foundation

/// Small application-level error taxonomy surfaced to view models.
enum AppError: Error, LocalizedError, Equatable {
    case network(String)
    case decoding(String)
    case pinning(String)
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .network(let message):
            return "Network error: \(message)"
        case .decoding(let message):
            return "Decoding error: \(message)"
        case .pinning(let message):
            return "Pinning error: \(message)"
        case .unknown(let message):
            return "Unknown error: \(message)"
        }
    }

    /// Maps any thrown error into the app-level taxonomy.
    static func map(_ error: Error) -> AppError {
        if let appError = error as? AppError {
            return appError
        }

        if let pinningError = error as? PinningError {
            return .pinning(pinningError.localizedDescription)
        }

        if let urlError = error as? URLError {
            return .network(urlError.localizedDescription)
        }

        if let decodingError = error as? DecodingError {
            return .decoding(String(describing: decodingError))
        }

        return .unknown(error.localizedDescription)
    }
}
