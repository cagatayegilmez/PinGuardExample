import Observation
import SwiftUI

/// Home feature screen rendered with SwiftUI.
struct HomeView: View {
    @Bindable var viewModel: HomeViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Button {
                    Task { await viewModel.testConnection() }
                } label: {
                    HStack {
                        Spacer()
                        if viewModel.status == .loading {
                            ProgressView()
                        } else {
                            Text("Test Connection")
                                .fontWeight(.semibold)
                        }
                        Spacer()
                    }
                }
                .buttonStyle(.borderedProminent)

                statusSection
                diagnosticsSection
                responseSection
            }
            .padding(16)
        }
        .navigationTitle("PinGuard Example")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Settings") {
                    viewModel.didTapSettings()
                }
            }
        }
    }

    private var statusSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Status")
                .font(.headline)

            Text(viewModel.status.rawValue.capitalized)
                .foregroundStyle(statusColor)

            if let code = viewModel.statusCode {
                Text("HTTP: \(code)")
            }

            if let duration = viewModel.durationMilliseconds {
                Text("Duration: \(duration) ms")
            }

            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundStyle(.red)
                    .font(.footnote)
            }
        }
    }

    private var diagnosticsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Pinning Diagnostics")
                .font(.headline)

            Text("Pinned Host: \(viewModel.pinnedHost)")

            Text("Active Pins:")
            ForEach(viewModel.activePinMasks, id: \.self) { pin in
                Text("- \(pin)")
                    .font(.caption.monospaced())
            }
        }
    }

    private var responseSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Response")
                .font(.headline)

            Text(viewModel.responseBody)
                .font(.caption.monospaced())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }

    private var statusColor: Color {
        switch viewModel.status {
        case .idle:
            return .secondary
        case .loading:
            return .orange
        case .success:
            return .green
        case .failure:
            return .red
        }
    }
}
