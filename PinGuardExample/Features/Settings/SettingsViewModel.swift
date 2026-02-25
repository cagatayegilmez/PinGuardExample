import Foundation
import Observation

/// View model for persisted runtime settings.
@MainActor
@Observable
final class SettingsViewModel {
    var usePinGuard: Bool
    var useBackupPinOnly: Bool

    private let settingsStore: SettingsStore
    private let onDismiss: () -> Void

    init(settingsStore: SettingsStore, onDismiss: @escaping () -> Void) {
        self.settingsStore = settingsStore
        self.onDismiss = onDismiss
        self.usePinGuard = settingsStore.usePinGuard
        self.useBackupPinOnly = settingsStore.useBackupPinOnly
    }

    /// Persists current values from the form.
    func save() {
        settingsStore.usePinGuard = usePinGuard
        settingsStore.useBackupPinOnly = useBackupPinOnly
    }

    /// Handles explicit close action.
    func close() {
        save()
        onDismiss()
    }
}
