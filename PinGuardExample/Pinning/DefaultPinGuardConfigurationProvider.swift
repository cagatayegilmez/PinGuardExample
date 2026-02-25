import Foundation
import PinGuard

/// Default provider that builds PinGuard policy from app settings.
struct DefaultPinGuardConfigurationProvider: PinGuardConfigurationProviding {
    private let settingsStore: SettingsStore
    private let host = "api.cagatayegilmez.com"

    init(settingsStore: SettingsStore) {
        self.settingsStore = settingsStore
    }

    func currentConfiguration() -> PinningTargetConfiguration {
        PinningTargetConfiguration(host: host, pins: activePins())
    }

    func makePolicySet() -> PolicySet {
        let pins = activePins().enumerated().map { index, value in
            Pin(
                type: .spki,
                hash: value,
                role: index == 0 ? .primary : .backup,
                scope: .leaf
            )
        }

        let policy = PinningPolicy(
            pins: pins,
            failStrategy: .strict,
            requireSystemTrust: true,
            allowSystemTrustFallback: false
        )

        let hostPolicy = HostPolicy(pattern: .exact(host), policy: policy)
        return PolicySet(policies: [hostPolicy])
    }

    func maskedPinsForDisplay() -> [String] {
        activePins().map { pin in
            let prefix = pin.prefix(6)
            return "\(prefix)..."
        }
    }

    private func activePins() -> [String] {
        if settingsStore.useBackupPinOnly {
            return [Secrets.backupSPKIPin]
        }

        return [Secrets.primarySPKIPin, Secrets.backupSPKIPin]
    }
}
