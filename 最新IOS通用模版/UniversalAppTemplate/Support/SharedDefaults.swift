import Foundation

enum SharedDefaults {
    static let settingsKey = "template.settings"
    static let featureFlagsKey = "template.feature-flags"
    static let latestSnapshotKey = "template.latest-snapshot"
    static let appUpdateLastCheckAtKey = "template.app-update.last-check-at"
    static let appUpdateLastPromptedVersionKey = "template.app-update.last-prompted-version"

    static var store: UserDefaults {
        .standard
    }

    static func loadSettings() -> AppSettings {
        guard
            let data = store.data(forKey: settingsKey),
            let decoded = try? JSONDecoder().decode(AppSettings.self, from: data)
        else {
            return AppSettings()
        }
        return decoded
    }

    static func saveSettings(_ settings: AppSettings) {
        guard let data = try? JSONEncoder().encode(settings) else { return }
        store.set(data, forKey: settingsKey)
    }

    static func loadFeatureFlags() -> FeatureFlags {
        guard
            let data = store.data(forKey: featureFlagsKey),
            let decoded = try? JSONDecoder().decode(FeatureFlags.self, from: data)
        else {
            return FeatureFlags()
        }
        return decoded
    }

    static func saveFeatureFlags(_ flags: FeatureFlags) {
        guard let data = try? JSONEncoder().encode(flags) else { return }
        store.set(data, forKey: featureFlagsKey)
    }

    static func loadLatestSnapshot() -> TemplateSnapshot? {
        guard
            let data = store.data(forKey: latestSnapshotKey),
            let decoded = try? JSONDecoder().decode(TemplateSnapshot.self, from: data)
        else {
            return nil
        }
        return decoded
    }

    static func saveLatestSnapshot(_ snapshot: TemplateSnapshot) {
        guard let data = try? JSONEncoder().encode(snapshot) else { return }
        store.set(data, forKey: latestSnapshotKey)
    }

    static func loadAppUpdateLastCheckAt() -> Date? {
        store.object(forKey: appUpdateLastCheckAtKey) as? Date
    }

    static func saveAppUpdateLastCheckAt(_ date: Date?) {
        if let date {
            store.set(date, forKey: appUpdateLastCheckAtKey)
        } else {
            store.removeObject(forKey: appUpdateLastCheckAtKey)
        }
    }

    static func loadAppUpdateLastPromptedVersion() -> String? {
        store.string(forKey: appUpdateLastPromptedVersionKey)
    }

    static func saveAppUpdateLastPromptedVersion(_ version: String?) {
        if let version, !version.isEmpty {
            store.set(version, forKey: appUpdateLastPromptedVersionKey)
        } else {
            store.removeObject(forKey: appUpdateLastPromptedVersionKey)
        }
    }

    static func clearTemplateState() {
        [
            settingsKey,
            featureFlagsKey,
            latestSnapshotKey,
            appUpdateLastCheckAtKey,
            appUpdateLastPromptedVersionKey
        ].forEach(store.removeObject(forKey:))
    }
}
