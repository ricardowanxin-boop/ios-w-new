import SwiftUI

struct ComponentsScreen: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: TemplateLayoutMetrics.sectionSpacing) {
                headerSection
                badgeSection
                metricSection
                buttonSection
                emptyStateSection
            }
            .padding(TemplateLayoutMetrics.contentPadding)
        }
        .background(AppBackgroundView())
        .navigationTitle("模板组件库")
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            TemplateSectionHeader(
                title: "组件沉淀区",
                subtitle: "把跨页面复用的卡片、状态、按钮和空态都先沉淀在这里，再进入真实业务实现。"
            )

            HStack(spacing: 10) {
                FeatureBadge(title: "状态", systemImage: "circle.grid.2x1")
                FeatureBadge(title: "卡片", systemImage: "rectangle.on.rectangle", tint: Color(hex: "#6EA8FE"))
                FeatureBadge(title: "按钮", systemImage: "cursorarrow.click.2", tint: AppTheme.success)
            }
        }
        .templateSurface(highlighted: true)
    }

    private var badgeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            TemplateSectionHeader(
                title: "状态徽标",
                subtitle: "适用于同步状态、审核状态、连接状态等轻量反馈。"
            )

            HStack(spacing: 10) {
                ForEach(SnapshotStatus.allCases, id: \.rawValue) { status in
                    StatusBadge(status: status)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .templateSurface()
    }

    private var metricSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            TemplateSectionHeader(
                title: "指标胶囊",
                subtitle: "适合首页摘要区和运营概览。"
            )

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                TemplateMetricPill(title: "活跃任务", value: "18 个", tintHex: "#FF7A50")
                TemplateMetricPill(title: "自动化规则", value: "6 条", tintHex: "#6EA8FE")
                TemplateMetricPill(title: "最近发布", value: "1.0.0", tintHex: "#12B76A")
                TemplateMetricPill(title: "平均响应", value: "320ms", tintHex: "#F79009")
            }
        }
        .templateSurface()
    }

    private var buttonSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            TemplateSectionHeader(
                title: "按钮样式",
                subtitle: "统一主次按钮后，后续接入导航、创建流和支付流都会更快。"
            )

            VStack(spacing: 12) {
                Button("主按钮样式") {}
                    .buttonStyle(TemplatePrimaryButtonStyle())

                Button("次按钮样式") {}
                    .buttonStyle(TemplateSecondaryButtonStyle())
            }
        }
        .templateSurface()
    }

    private var emptyStateSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            TemplateSectionHeader(
                title: "空态",
                subtitle: "拿来承接首屏无内容、新用户引导或搜索无结果。"
            )

            EmptyStateCard(
                title: "还没有真实数据",
                subtitle: "在这里接入网络层、本地数据库或 AI 结果后，就可以把空态替换成真实列表。",
                systemImage: "shippingbox"
            )
        }
        .templateSurface()
    }
}
