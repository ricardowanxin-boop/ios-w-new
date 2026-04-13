import SwiftUI

struct HomeScreen: View {
    @ObservedObject var viewModel: HomeViewModel
    @ObservedObject var settingsStore: AppSettingsStore
    let onAction: (QuickActionItem) -> Void

    private var metricColumns: [GridItem] {
        let count = settingsStore.settings.compactMetrics ? 3 : 2
        return Array(repeating: GridItem(.flexible(), spacing: 12), count: count)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: TemplateLayoutMetrics.sectionSpacing) {
                heroSection
                metricsSection
                quickActionsSection
                timelineSection
            }
            .padding(TemplateLayoutMetrics.contentPadding)
        }
        .background(AppBackgroundView())
        .navigationTitle("首页骨架")
        .refreshable {
            await viewModel.refresh(showMessage: false)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task {
                        await viewModel.refresh(showMessage: false)
                    }
                } label: {
                    if viewModel.isRefreshing {
                        ProgressView()
                            .controlSize(.small)
                    } else {
                        Image(systemName: "arrow.clockwise")
                    }
                }
                .accessibilityIdentifier("dashboard-refresh-button")
            }
        }
    }

    private var heroSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(AppConfig.appDisplayName)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(AppTheme.textSecondary)

                    Text(viewModel.snapshot.headline)
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundStyle(AppTheme.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(viewModel.snapshot.subheadline)
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 16)

                StatusBadge(status: viewModel.snapshot.status)
            }

            FeatureBadge(title: "更新于 \(DisplayFormatters.relative(viewModel.snapshot.updatedAt))", systemImage: "clock")

            Text(viewModel.snapshot.featuredNote)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(AppTheme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 6)
        }
        .templateSurface(highlighted: true)
        .accessibilityIdentifier("dashboard-hero-card")
    }

    private var metricsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            TemplateSectionHeader(
                title: "指标区示例",
                subtitle: "这里适合承载核心 KPI、运营摘要或 AI 生成结果。"
            )

            LazyVGrid(columns: metricColumns, spacing: 12) {
                ForEach(viewModel.snapshot.metrics) { metric in
                    TemplateMetricPill(
                        title: metric.title,
                        value: metric.value,
                        tintHex: metric.tintHex
                    )
                }
            }
        }
        .templateSurface()
    }

    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            TemplateSectionHeader(
                title: "快捷入口",
                subtitle: "适合沉淀创建、导入、跳转和引导型操作。"
            )

            VStack(spacing: 12) {
                ForEach(viewModel.snapshot.quickActions) { action in
                    Button {
                        onAction(action)
                    } label: {
                        HStack(spacing: 14) {
                            Image(systemName: action.systemImage)
                                .font(.headline.weight(.semibold))
                                .foregroundStyle(AppTheme.accent)
                                .frame(width: 28)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(action.title)
                                    .font(.headline.weight(.semibold))
                                    .foregroundStyle(AppTheme.textPrimary)

                                Text(action.subtitle)
                                    .font(.subheadline)
                                    .foregroundStyle(AppTheme.textSecondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(AppTheme.textTertiary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .buttonStyle(TemplateSecondaryButtonStyle())
                    .accessibilityIdentifier("quick-action-\(action.id)")
                }
            }
        }
        .templateSurface()
    }

    private var timelineSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            TemplateSectionHeader(
                title: "活动流示例",
                subtitle: "适合展示最近更新、待办、消息摘要或用户行为。"
            )

            if viewModel.snapshot.timeline.isEmpty {
                EmptyStateCard(
                    title: "这里还没有内容",
                    subtitle: "你可以把它替换为真实的最近活动、消息列表或待办清单。",
                    systemImage: "tray"
                )
            } else {
                VStack(spacing: 12) {
                    ForEach(viewModel.snapshot.timeline) { item in
                        ActivityRow(item: item)
                    }
                }
            }
        }
        .templateSurface()
    }
}

private struct ActivityRow: View {
    let item: ActivityItem

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(AppTheme.accent.opacity(0.15))
                .frame(width: 40, height: 40)
                .overlay {
                    Image(systemName: "sparkles")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(AppTheme.accent)
                }

            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .firstTextBaseline) {
                    Text(item.title)
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(AppTheme.textPrimary)

                    Spacer(minLength: 12)

                    Text(DisplayFormatters.relative(item.timestamp))
                        .font(.caption)
                        .foregroundStyle(AppTheme.textTertiary)
                }

                Text(item.detail)
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(AppTheme.surfaceWarm, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(AppTheme.divider, lineWidth: 1)
        )
    }
}
