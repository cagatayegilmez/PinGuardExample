import Foundation

/// Base coordinator protocol for navigation orchestration.
protocol Coordinator: AnyObject {
    /// Starts the navigation flow owned by this coordinator.
    func start()
}
