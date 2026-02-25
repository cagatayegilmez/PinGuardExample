import Foundation

/// `SettingsStore` backed by `UserDefaults`.
final class UserDefaultsSettingsStore: SettingsStore {
    private enum Keys {
        static let usePinGuard = "settings.usePinGuard"
        static let useBackupPinOnly = "settings.useBackupPinOnly"
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        defaults.register(defaults: [
            Keys.usePinGuard: true,
            Keys.useBackupPinOnly: false
        ])
    }

    var usePinGuard: Bool {
        get { defaults.bool(forKey: Keys.usePinGuard) }
        set { defaults.set(newValue, forKey: Keys.usePinGuard) }
    }

    var useBackupPinOnly: Bool {
        get { defaults.bool(forKey: Keys.useBackupPinOnly) }
        set { defaults.set(newValue, forKey: Keys.useBackupPinOnly) }
    }
}
