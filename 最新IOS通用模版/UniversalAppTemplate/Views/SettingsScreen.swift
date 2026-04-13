import SwiftUI

struct SettingsScreen: View {
    @ObservedObject var settingsStore: AppSettingsStore
    @ObservedObject var featureFlagStore: FeatureFlagStore
    @ObservedObject var appUpdateStore: AppUpdateStore
    @ObservedObject var viewModel: HomeViewModel
    let onMessage: (String) -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: TemplateLayoutMetrics.sectionSpacing) {
                appearanceSection
                behaviorSection
                debugSection
                appInfoSection
            }
            .padding(TemplateLayoutMetrics.contentPadding)
        }
        .background(AppBackgroundView())
        .navigationTitle("设置")
    }

    private var appearanceSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            TemplateSectionHeader(
                title: "外观与体验",
                subtitle: "这部分保留了最常用的模板级设置项，替换时可以继续追加业务偏好。"
            )

            Picker("主题模式", selection: $settingsStore.settings.appearance) {
                ForEach(AppAppearance.allCases) { appearance in
                    Text(appearance.title).tag(appearance)
                }
            }
            .pickerStyle(.segmented)

            Toggle("首页使用紧凑指标布局", isOn: $settingsStore.settings.compactMetrics)
            Toggle("启动时自动检查示例数据", isOn: $settingsStore.settings.autoRefreshOnLaunch)
            Toggle("保留触感反馈开关", isOn: $settingsStore.settings.enableHaptics)
        }
        .templateSurface()
    }

    private var behaviorSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            TemplateSectionHeader(
                title: "模板开关",
                subtitle: "建议把非核心能力先挂在这里，方便灰度和快速裁剪。"
            )

            Toggle("显示组件实验页", isOn: $featureFlagStore.flags.showsComponentLab)
            Toggle("启用 App Store 版本检查", isOn: $featureFlagStore.flags.enablesAppUpdateCheck)
            Toggle("启用本地快照缓存", isOn: $featureFlagStore.flags.usesPersistentSnapshotCache)
        }
        .templateSurface()
    }

    private var debugSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            TemplateSectionHeader(
                title: "调试动作",
                subtitle: "这些按钮适合保留在内部调试版或测试环境。"
            )

            Button {
                Task {
                    await viewModel.refresh()
                }
            } label: {
                Label("手动刷新首页示例", systemImage: "arrow.clockwise")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(TemplateSecondaryButtonStyle())

            Button {
                Task {
                    await viewModel.resetToSampleData()
                }
            } label: {
                Label("重置模板数据", systemImage: "arrow.counterclockwise")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(TemplateSecondaryButtonStyle())
            .accessibilityIdentifier("settings-reset-template-data")

            Button {
                Task {
                    let result = await appUpdateStore.checkForUpdates(trigger: .manual)
                    handleUpdateCheckResult(result)
                }
            } label: {
                HStack {
                    Label("检查 App Store 更新", systemImage: "square.and.arrow.down")
                    Spacer()
                    if appUpdateStore.isChecking {
                        ProgressView()
                            .controlSize(.small)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(TemplatePrimaryButtonStyle())
            .disabled(!featureFlagStore.flags.enablesAppUpdateCheck || appUpdateStore.isChecking)
            .accessibilityIdentifier("settings-check-update-button")

            Text(appUpdateStore.settingsStatusSummary)
                .font(.footnote)
                .foregroundStyle(AppTheme.textSecondary)
        }
        .templateSurface()
    }

    private var appInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            TemplateSectionHeader(
                title: "模板信息",
                subtitle: "把这里替换成你自己的 Bundle ID、支持地址和产品文档。"
            )

            KeyValueRow(title: "Bundle ID", value: AppConfig.bundleIdentifier)
            KeyValueRow(title: "模板版本", value: AppConfig.templateVersion)
            KeyValueRow(title: "最低系统", value: AppConfig.minimumOSVersion)
            KeyValueRow(title: "支持邮箱", value: AppConfig.supportEmail)

            VStack(spacing: 10) {
                Link(destination: AppConfig.docsURL) {
                    Label("打开模板文档占位地址", systemImage: "doc.text")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(TemplateSecondaryButtonStyle())

                Link(destination: AppConfig.supportURL) {
                    Label("打开支持页占位地址", systemImage: "lifepreserver")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(TemplateSecondaryButtonStyle())

                Link(destination: AppConfig.privacyPolicyURL) {
                    Label("打开隐私页占位地址", systemImage: "hand.raised")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(TemplateSecondaryButtonStyle())
            }
        }
        .templateSurface()
    }

    private func handleUpdateCheckResult(_ result: AppUpdateCheckResult) {
        switch result {
        case .skippedAutomaticWindow, .checkingInProgress:
            break
        case .upToDate:
            onMessage("当前已经是最新版本。")
        case .updateAvailable:
            break
        case .unavailable(let message):
            onMessage(message)
        }
    }
}
