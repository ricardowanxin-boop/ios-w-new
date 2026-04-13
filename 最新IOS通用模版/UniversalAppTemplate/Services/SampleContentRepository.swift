import Foundation

actor SampleContentRepository {
    private let fileStore = JSONFileStore()
    private let filename = "dashboard-snapshot.json"

    func loadSnapshot() async -> TemplateSnapshot {
        if AppRuntime.isUITesting {
            return SampleData.snapshot
        }

        if SharedDefaults.loadFeatureFlags().usesPersistentSnapshotCache,
           let cached = try? fileStore.load(TemplateSnapshot.self, from: filename) {
            return cached
        }

        let snapshot = SampleData.snapshot
        persist(snapshot)
        return snapshot
    }

    func refreshSnapshot(current: TemplateSnapshot?) async -> TemplateSnapshot {
        try? await Task.sleep(for: .milliseconds(320))

        let refreshed = SampleData.refreshedSnapshot(from: current)
        persist(refreshed)
        return refreshed
    }

    func resetSnapshot() async -> TemplateSnapshot {
        let snapshot = SampleData.snapshot
        persist(snapshot)
        return snapshot
    }

    private func persist(_ snapshot: TemplateSnapshot) {
        guard SharedDefaults.loadFeatureFlags().usesPersistentSnapshotCache else {
            try? fileStore.remove(filename)
            return
        }

        try? fileStore.save(snapshot, as: filename)
    }
}
