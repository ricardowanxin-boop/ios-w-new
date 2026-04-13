import Foundation

enum SampleData {
    static var snapshot: TemplateSnapshot {
        makeSnapshot(referenceDate: Date(), status: .ready)
    }

    static func refreshedSnapshot(from current: TemplateSnapshot?) -> TemplateSnapshot {
        let seedDate = Date()
        let minute = Calendar.current.component(.minute, from: seedDate)

        let status: SnapshotStatus
        switch minute % 3 {
        case 0:
            status = .ready
        case 1:
            status = .syncing
        default:
            status = .offline
        }

        return makeSnapshot(referenceDate: seedDate, status: status, previous: current)
    }

    private static func makeSnapshot(
        referenceDate: Date,
        status: SnapshotStatus,
        previous: TemplateSnapshot? = nil
    ) -> TemplateSnapshot {
        let freshnessValue = max(1, 12 - Calendar.current.component(.minute, from: referenceDate) % 9)
        let cardsValue = previous?.timeline.count ?? 4
        let releaseValue = previous?.metrics.last?.value ?? "1.0.0"

        return TemplateSnapshot(
            headline: "把这套骨架替换成你的业务首页",
            subheadline: "这里保留了主题、状态、指标、组件预览、设置和本地持久化结构，适合快速改造成 SaaS、内容、工具或 AI 类应用。",
            status: status,
            metrics: [
                DashboardMetric(id: "freshness", title: "内容新鲜度", value: "\(freshnessValue) 分钟", tintHex: "#FF7A50"),
                DashboardMetric(id: "cards", title: "首页模块", value: "\(cardsValue) 个", tintHex: "#6EA8FE"),
                DashboardMetric(id: "release", title: "模板版本", value: releaseValue, tintHex: "#12B76A")
            ],
            quickActions: [
                QuickActionItem(
                    id: "refresh-data",
                    title: "刷新示例数据",
                    subtitle: "演示异步刷新和状态切换",
                    systemImage: "arrow.clockwise",
                    feedbackMessage: "示例数据已经刷新。"
                ),
                QuickActionItem(
                    id: "open-components",
                    title: "查看组件库",
                    subtitle: "统一沉淀卡片、徽标和按钮样式",
                    systemImage: "square.grid.2x2",
                    feedbackMessage: "已经切换到组件页。"
                ),
                QuickActionItem(
                    id: "open-settings",
                    title: "检查模板设置",
                    subtitle: "把外观、功能开关和 App 信息集中管理",
                    systemImage: "gearshape.2",
                    feedbackMessage: "已经切换到设置页。"
                )
            ],
            timeline: [
                ActivityItem(
                    id: "arch-1",
                    title: "首页结构已准备好",
                    detail: "你可以把 Hero、指标区、活动流替换成真实业务信息。",
                    timestamp: referenceDate.addingTimeInterval(-600)
                ),
                ActivityItem(
                    id: "arch-2",
                    title: "组件库页已接通",
                    detail: "统一维护设计 token、状态徽标和按钮样式，后续扩展会更稳。",
                    timestamp: referenceDate.addingTimeInterval(-1800)
                ),
                ActivityItem(
                    id: "arch-3",
                    title: "设置页已接通本地持久化",
                    detail: "主题模式、功能开关和调试动作都可以直接落地到 UserDefaults。",
                    timestamp: referenceDate.addingTimeInterval(-3600)
                ),
                ActivityItem(
                    id: "arch-4",
                    title: "App Store 更新检测已预留",
                    detail: "替换 Bundle ID 并上架后，这里就能直接复用版本检查逻辑。",
                    timestamp: referenceDate.addingTimeInterval(-7200)
                )
            ],
            featuredNote: status.detail,
            updatedAt: referenceDate
        )
    }
}
