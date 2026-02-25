import Foundation

/// Abstraction around persisted runtime flags.
protocol SettingsStore: AnyObject {
    /// Whether all requests should go through PinGuard.
    var usePinGuard: Bool { get set }
    /// Whether only backup pin should be used when pinning is enabled.
    var useBackupPinOnly: Bool { get set }
}
