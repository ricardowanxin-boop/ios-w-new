import Foundation
import SwiftUI

enum AppAppearance: String, Codable, CaseIterable, Identifiable {
    case system
    case light
    case dark

    var id: String { rawValue }

    var title: String {
        switch self {
        case .system:
            return "跟随系统"
        case .light:
            return "浅色"
        case .dark:
            return "深色"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

struct AppSettings: Codable, Equatable {
    var appearance: AppAppearance = .system
    var compactMetrics = false
    var autoRefreshOnLaunch = true
    var enableHaptics = true
}

struct FeatureFlags: Codable, Equatable {
    var showsComponentLab = true
    var enablesAppUpdateCheck = true
    var usesPersistentSnapshotCache = true
}

enum SnapshotStatus: String, Codable, CaseIterable {
    case ready
    case syncing
    case offline

    var title: String {
        switch self {
        case .ready:
            return "已就绪"
        case .syncing:
            return "同步中"
        case .offline:
            return "离线模式"
        }
    }

    var detail: String {
        switch self {
        case .ready:
            return "模板数据已经加载完成，可直接在此基础上替换成真实业务。"
        case .syncing:
            return "演示刷新状态，适合接入接口、缓存或本地数据库。"
        case .offline:
            return "演示无网兜底页面和本地持久化结构。"
        }
    }
}

struct DashboardMetric: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    let value: String
    let tintHex: String
}

struct QuickActionItem: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    let subtitle: String
    let systemImage: String
    let feedbackMessage: String
}

struct ActivityItem: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    let detail: String
    let timestamp: Date
}

struct TemplateSnapshot: Codable, Equatable {
    var headline: String
    var subheadline: String
    var status: SnapshotStatus
    var metrics: [DashboardMetric]
    var quickActions: [QuickActionItem]
    var timeline: [ActivityItem]
    var featuredNote: String
    var updatedAt: Date
}
