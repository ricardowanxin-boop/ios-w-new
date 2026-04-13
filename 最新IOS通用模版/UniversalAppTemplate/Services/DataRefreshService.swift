import Foundation

actor DataRefreshService {
    private let repository: SampleContentRepository

    init(repository: SampleContentRepository = SampleContentRepository()) {
        self.repository = repository
    }

    func loadInitialSnapshot() async -> TemplateSnapshot {
        await repository.loadSnapshot()
    }

    func refreshSnapshot(current: TemplateSnapshot?) async -> TemplateSnapshot {
        await repository.refreshSnapshot(current: current)
    }

    func resetSnapshot() async -> TemplateSnapshot {
        await repository.resetSnapshot()
    }
}
