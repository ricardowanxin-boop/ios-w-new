import SwiftUI

enum TemplateLayoutMetrics {
    static let contentPadding: CGFloat = 20
    static let sectionSpacing: CGFloat = 18
    static let controlHeight: CGFloat = 52
}

struct TemplateSectionHeader: View {
    let title: String
    var subtitle: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.title3.weight(.bold))
                .foregroundStyle(AppTheme.textPrimary)

            if let subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct StatusBadge: View {
    let status: SnapshotStatus

    var body: some View {
        Label {
            Text(status.title)
                .font(.caption.weight(.semibold))
        } icon: {
            Circle()
                .fill(AppTheme.statusTint(for: status))
                .frame(width: 8, height: 8)
        }
        .foregroundStyle(AppTheme.statusTint(for: status))
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(AppTheme.statusTint(for: status).opacity(0.12), in: Capsule())
    }
}

struct FeatureBadge: View {
    let title: String
    let systemImage: String
    var tint: Color = AppTheme.accent

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.caption.weight(.bold))
            Text(title)
                .font(.caption.weight(.semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .foregroundStyle(tint)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(tint.opacity(0.12), in: Capsule())
    }
}

struct TemplateMetricPill: View {
    let title: String
    let value: String
    var tintHex: String

    private var tint: Color {
        Color(hex: tintHex)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption.weight(.medium))
                .foregroundStyle(AppTheme.textSecondary)
            Text(value)
                .font(.title3.weight(.bold))
                .lineLimit(1)
                .minimumScaleFactor(0.85)
                .foregroundStyle(tint)
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

struct KeyValueRow: View {
    let title: String
    let value: String

    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(alignment: .top, spacing: 12) {
                titleView
                    .layoutPriority(1)

                Spacer(minLength: 16)

                valueView(multilineAlignment: .trailing)
            }

            VStack(alignment: .leading, spacing: 6) {
                titleView
                valueView(multilineAlignment: .leading)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var titleView: some View {
        Text(title)
            .font(.subheadline.weight(.medium))
            .foregroundStyle(AppTheme.textSecondary)
            .fixedSize(horizontal: false, vertical: true)
    }

    private func valueView(multilineAlignment: TextAlignment) -> some View {
        Text(value)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(AppTheme.textPrimary)
            .multilineTextAlignment(multilineAlignment)
            .fixedSize(horizontal: false, vertical: true)
    }
}

struct EmptyStateCard: View {
    let title: String
    let subtitle: String
    let systemImage: String

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: systemImage)
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(AppTheme.accent)

            Text(title)
                .font(.headline.weight(.semibold))
                .foregroundStyle(AppTheme.textPrimary)

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(AppTheme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .templateSurface()
    }
}

struct TemplatePrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
            .background(AppTheme.accent.opacity(configuration.isPressed ? 0.82 : 1.0), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .foregroundStyle(Color.white)
            .scaleEffect(configuration.isPressed ? 0.985 : 1.0)
            .animation(.easeOut(duration: 0.14), value: configuration.isPressed)
    }
}

struct TemplateSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
            .background(AppTheme.surfaceWarm, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(AppTheme.divider, lineWidth: 1)
            )
            .foregroundStyle(AppTheme.textPrimary)
            .scaleEffect(configuration.isPressed ? 0.985 : 1.0)
            .animation(.easeOut(duration: 0.14), value: configuration.isPressed)
    }
}
