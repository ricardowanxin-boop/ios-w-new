import Foundation
import SwiftUI

enum AppUpdateCheckTrigger {
    case automatic
    case manual
}

enum AppUpdateCheckResult: Equatable {
    case skippedAutomaticWindow
    case checkingInProgress
    case upToDate
    case updateAvailable(AvailableAppUpdate)
    case unavailable(message: String)
}

struct AvailableAppUpdate: Identifiable, Equatable {
    let currentVersion: String
    let currentBuild: String
    let appStoreVersion: String
    let storeURL: URL
    let releaseNotes: String?
    let releasedAt: Date?

    var id: String { appStoreVersion }
    var currentVersionSummary: String { "\(currentVersion) (\(currentBuild))" }
}

private struct AppStoreLookupResponse: Decodable {
    let results: [AppStoreLookupItem]
}

private struct AppStoreLookupItem: Decodable {
    let bundleId: String
    let version: String
    let releaseNotes: String?
    let currentVersionReleaseDate: Date?
    let trackViewUrl: URL?
    let trackId: Int?
}

struct AppStoreRelease {
    let version: String
    let storeURL: URL
    let releaseNotes: String?
    let releasedAt: Date?
}

protocol AppStoreLookupServing {
    func fetchLatestRelease(bundleID: String) async throws -> AppStoreRelease?
}

struct AppStoreLookupService: AppStoreLookupServing {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared) {
        self.session = session
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder
    }

    func fetchLatestRelease(bundleID: String) async throws -> AppStoreRelease? {
        for storefront in candidateStorefronts() {
            guard let url = lookupURL(bundleID: bundleID, countryCode: storefront) else { continue }
            let (data, response) = try await session.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse, 200 ..< 300 ~= httpResponse.statusCode else {
                throw URLError(.badServerResponse)
            }

            let payload = try decoder.decode(AppStoreLookupResponse.self, from: data)
            guard let match = payload.results.first(where: { $0.bundleId == bundleID }) else {
                continue
            }

            guard let storeURL = resolvedStoreURL(for: match) else {
                continue
            }

            let notes = match.releaseNotes?.trimmingCharacters(in: .whitespacesAndNewlines)
            return AppStoreRelease(
                version: match.version,
                storeURL: storeURL,
                releaseNotes: notes?.isEmpty == false ? notes : nil,
                releasedAt: match.currentVersionReleaseDate
            )
        }

        return nil
    }

    private func candidateStorefronts() -> [String] {
        var storefronts: [String] = []

        if let regionCode = Locale.autoupdatingCurrent.region?.identifier, regionCode.count == 2 {
            storefronts.append(regionCode.uppercased())
        }

        storefronts.append(contentsOf: AppConfig.preferredStorefronts)
        storefronts.append("US")

        var deduplicated: [String] = []
        for storefront in storefronts where !deduplicated.contains(storefront) {
            deduplicated.append(storefront)
        }
        return deduplicated
    }

    private func lookupURL(bundleID: String, countryCode: String) -> URL? {
        var components = URLComponents(string: "https://itunes.apple.com/lookup")
        components?.queryItems = [
            URLQueryItem(name: "bundleId", value: bundleID),
            URLQueryItem(name: "country", value: countryCode)
        ]
        return components?.url
    }

    private func resolvedStoreURL(for item: AppStoreLookupItem) -> URL? {
        if let trackViewUrl = item.trackViewUrl {
            return trackViewUrl
        }

        guard let trackId = item.trackId else { return nil }
        return URL(string: "https://apps.apple.com/app/id\(trackId)")
    }
}

@MainActor
final class AppUpdateStore: ObservableObject {
    @Published private(set) var isChecking = false
    @Published private(set) var lastCheckedAt: Date?
    @Published private(set) var latestKnownVersion: String?
    @Published private(set) var lastErrorMessage: String?
    @Published var presentedUpdate: AvailableAppUpdate?

    private let lookupService: AppStoreLookupServing
    private let automaticCheckInterval: TimeInterval

    init(
        lookupService: AppStoreLookupServing = AppStoreLookupService(),
        automaticCheckInterval: TimeInterval = 60 * 60 * 24
    ) {
        self.lookupService = lookupService
        self.automaticCheckInterval = automaticCheckInterval
        lastCheckedAt = SharedDefaults.loadAppUpdateLastCheckAt()
    }

    var currentVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0.0"
    }

    var currentBuild: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
    }

    var settingsStatusSummary: String {
        if isChecking {
            return "正在连接 App Store…"
        }

        if let latestKnownVersion, Self.isVersion(latestKnownVersion, newerThan: currentVersion) {
            return "发现新版本 \(latestKnownVersion)"
        }

        if let latestKnownVersion {
            return "当前已是最新版 \(latestKnownVersion)"
        }

        if let lastErrorMessage {
            return lastErrorMessage
        }

        if let lastCheckedAt {
            return "上次检查 \(DisplayFormatters.relative(lastCheckedAt))"
        }

        return "尚未检查更新"
    }

    func checkForUpdates(trigger: AppUpdateCheckTrigger) async -> AppUpdateCheckResult {
        guard !AppRuntime.isUITesting else {
            return .unavailable(message: "UI 测试环境已跳过 App Store 版本检查。")
        }

        guard !isChecking else {
            return .checkingInProgress
        }

        if trigger == .automatic,
           let lastCheckedAt,
           Date().timeIntervalSince(lastCheckedAt) < automaticCheckInterval {
            return .skippedAutomaticWindow
        }

        isChecking = true
        defer { isChecking = false }

        do {
            let release = try await lookupService.fetchLatestRelease(bundleID: AppConfig.bundleIdentifier)
            let checkedAt = Date()
            lastCheckedAt = checkedAt
            SharedDefaults.saveAppUpdateLastCheckAt(checkedAt)

            guard let release else {
                latestKnownVersion = nil
                lastErrorMessage = "当前 Bundle ID 尚未在 App Store 上架"
                return .unavailable(message: "当前模板还没有公开的 App Store 条目，替换成你自己的 Bundle ID 和商店版本后即可启用。")
            }

            latestKnownVersion = release.version
            lastErrorMessage = nil

            guard Self.isVersion(release.version, newerThan: currentVersion) else {
                return .upToDate
            }

            let update = AvailableAppUpdate(
                currentVersion: currentVersion,
                currentBuild: currentBuild,
                appStoreVersion: release.version,
                storeURL: release.storeURL,
                releaseNotes: release.releaseNotes,
                releasedAt: release.releasedAt
            )

            if trigger == .manual || SharedDefaults.loadAppUpdateLastPromptedVersion() != release.version {
                SharedDefaults.saveAppUpdateLastPromptedVersion(release.version)
                presentedUpdate = update
            }

            return .updateAvailable(update)
        } catch {
            let checkedAt = Date()
            lastCheckedAt = checkedAt
            SharedDefaults.saveAppUpdateLastCheckAt(checkedAt)

            let message: String
            if let urlError = error as? URLError {
                switch urlError.code {
                case .notConnectedToInternet, .networkConnectionLost, .timedOut:
                    message = "当前网络不可用，稍后再试"
                default:
                    message = "暂时无法连接 App Store"
                }
            } else {
                message = "暂时无法连接 App Store"
            }

            lastErrorMessage = message
            return .unavailable(message: message)
        }
    }

    func dismissPresentedUpdate() {
        presentedUpdate = nil
    }

    private static func isVersion(_ lhs: String, newerThan rhs: String) -> Bool {
        lhs.compare(rhs, options: .numeric) == .orderedDescending
    }
}

struct AppUpdateSheet: View {
    let update: AvailableAppUpdate
    let dismiss: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("发现新版本")
                        .font(.largeTitle.weight(.bold))
                    Text("当前版本 \(update.currentVersionSummary)")
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.textSecondary)
                }

                VStack(alignment: .leading, spacing: 12) {
                    KeyValueRow(title: "最新版本", value: update.appStoreVersion)

                    if let releasedAt = update.releasedAt {
                        KeyValueRow(title: "发布时间", value: DisplayFormatters.dateTime(releasedAt))
                    }
                }
                .templateSurface()

                VStack(alignment: .leading, spacing: 12) {
                    TemplateSectionHeader(
                        title: "更新说明",
                        subtitle: update.releaseNotes?.isEmpty == false
                            ? "下面是从 App Store 返回的版本说明。"
                            : "这个版本暂时没有公开的更新说明。"
                    )

                    Text(update.releaseNotes ?? "暂无发布说明。")
                        .font(.body)
                        .foregroundStyle(AppTheme.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .templateSurface(highlighted: true)

                Link(destination: update.storeURL) {
                    Label("前往 App Store", systemImage: "arrow.up.right.square")
                        .font(.headline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(TemplatePrimaryButtonStyle())
            }
            .padding(20)
        }
        .background(AppBackgroundView())
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("关闭", action: dismiss)
            }
        }
    }
}
