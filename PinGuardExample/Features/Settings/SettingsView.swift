import Observation
import SwiftUI

/// Settings screen rendered with SwiftUI and hosted in UIKit navigation.
struct SettingsView: View {
    @Bindable var viewModel: SettingsViewModel

    var body: some View {
        Form {
            Section("Pinning") {
                Toggle("Use PinGuard", isOn: $viewModel.usePinGuard)
                Toggle("Use Backup Pin Only", isOn: $viewModel.useBackupPinOnly)
            }
        }
        .navigationTitle("Settings")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    viewModel.close()
                }
            }
        }
        .onDisappear {
            viewModel.save()
        }
    }
}
