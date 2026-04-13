import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var snapshot: TemplateSnapshot
    @Published private(set) var isRefreshing = false
    @Published var transientMessage: String?

    private let refreshService: DataRefreshService
    private var hasLoaded = false

    init(refreshService: DataRefreshService = DataRefreshService()) {
        self.refreshService = refreshService
        snapshot = SharedDefaults.loadLatestSnapshot() ?? SampleData.snapshot
    }

    func loadIfNeeded() async {
        guard !hasLoaded else { return }
        hasLoaded = true
        snapshot = await refreshService.loadInitialSnapshot()
        SharedDefaults.saveLatestSnapshot(snapshot)
    }

    func refresh(showMessage: Bool = true) async {
        guard !isRefreshing else { return }
        isRefreshing = true
        defer { isRefreshing = false }

        snapshot = await refreshService.refreshSnapshot(current: snapshot)
        SharedDefaults.saveLatestSnapshot(snapshot)

        if showMessage {
            transientMessage = "示例数据已刷新。"
        }
    }

    func resetToSampleData() async {
        snapshot = await refreshService.resetSnapshot()
        SharedDefaults.saveLatestSnapshot(snapshot)
        transientMessage = "模板数据已经恢复到初始状态。"
    }

    func presentMessage(_ message: String) {
        transientMessage = message
    }
}
