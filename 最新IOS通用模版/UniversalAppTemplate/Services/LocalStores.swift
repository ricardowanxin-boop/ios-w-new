import Foundation
import SwiftUI

private actor DebouncedSettingsPersistence {
    private var pendingTask: Task<Void, Never>?

    func scheduleSave(_ settings: AppSettings) {
        pendingTask?.cancel()

        pendingTask = Task {
            do {
                try await Task.sleep(for: .milliseconds(120))
            } catch {
                return
            }

            guard !Task.isCancelled else { return }
            SharedDefaults.saveSettings(settings)
        }
    }
}

@MainActor
final class AppSettingsStore: ObservableObject {
    @Published var settings: AppSettings {
        didSet {
            guard settings != oldValue else { return }
            Task {
                await persistence.scheduleSave(settings)
            }
        }
    }

    private let persistence = DebouncedSettingsPersistence()

    init() {
        settings = SharedDefaults.loadSettings()
    }
}
