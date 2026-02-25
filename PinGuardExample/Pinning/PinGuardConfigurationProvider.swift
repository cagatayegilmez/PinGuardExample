import Foundation
import PinGuard

/// Value object describing active pinning inputs.
struct PinningTargetConfiguration: Sendable {
    let host: String
    let pins: [String]
}

/// Abstraction for retrieving PinGuard configuration at runtime.
protocol PinGuardConfigurationProviding {
    /// Returns host + active pin list according to current app settings.
    func currentConfiguration() -> PinningTargetConfiguration
    /// Returns host policy set to pass into PinGuard.
    func makePolicySet() -> PolicySet
    /// Returns display-safe masks for diagnostics UI.
    func maskedPinsForDisplay() -> [String]
}
