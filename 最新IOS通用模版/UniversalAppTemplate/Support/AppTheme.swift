import SwiftUI
import UIKit

enum AppTheme {
    static let backgroundTop = dynamicColor(light: "#FFF9F4", dark: "#121519")
    static let backgroundBottom = dynamicColor(light: "#F6F7FB", dark: "#0B1016")
    static let surface = dynamicColor(light: "#FFFFFF", dark: "#161C24")
    static let surfaceWarm = dynamicColor(light: "#FFF4EB", dark: "#1D252E")
    static let surfaceTint = dynamicColor(light: "#FFF1E7", dark: "#202C38")
    static let divider = dynamicColor(light: "#E5E7EB", dark: "#2E3745")
    static let textPrimary = dynamicColor(light: "#15171A", dark: "#F4F7FA")
    static let textSecondary = dynamicColor(light: "#667085", dark: "#BBC4D0")
    static let textTertiary = dynamicColor(light: "#98A2B3", dark: "#8D98AA")
    static let accent = dynamicColor(light: "#FF7A50", dark: "#FF9E7C")
    static let accentSoft = dynamicColor(light: "#FFB088", dark: "#D78E70")
    static let success = dynamicColor(light: "#12B76A", dark: "#47D892")
    static let warning = dynamicColor(light: "#F79009", dark: "#FFBF47")
    static let danger = dynamicColor(light: "#F04438", dark: "#FF847C")
    static let shadow = dynamicColor(
        light: UIColor.black.withAlphaComponent(0.08),
        dark: UIColor.black.withAlphaComponent(0.28)
    )

    static func statusTint(for status: SnapshotStatus) -> Color {
        switch status {
        case .ready:
            return success
        case .syncing:
            return warning
        case .offline:
            return danger
        }
    }
}

struct AppBackgroundView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [AppTheme.backgroundTop, AppTheme.backgroundBottom],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            RadialGradient(
                colors: [AppTheme.accentSoft.opacity(0.22), .clear],
                center: .topLeading,
                startRadius: 12,
                endRadius: 240
            )
            .offset(x: -40, y: -120)

            RadialGradient(
                colors: [Color(hex: "#6EA8FE").opacity(0.12), .clear],
                center: .bottomTrailing,
                startRadius: 20,
                endRadius: 200
            )
            .offset(x: 56, y: 160)
        }
        .ignoresSafeArea()
    }
}

private struct TemplateSurfaceModifier: ViewModifier {
    var highlighted: Bool

    func body(content: Content) -> some View {
        content
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(highlighted ? AppTheme.surfaceWarm : AppTheme.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(highlighted ? AppTheme.accentSoft.opacity(0.7) : AppTheme.divider, lineWidth: 1)
            )
            .shadow(color: AppTheme.shadow, radius: highlighted ? 18 : 12, x: 0, y: highlighted ? 10 : 6)
    }
}

extension View {
    func templateSurface(highlighted: Bool = false) -> some View {
        modifier(TemplateSurfaceModifier(highlighted: highlighted))
    }
}

private extension AppTheme {
    static func dynamicColor(light: String, dark: String) -> Color {
        dynamicColor(light: UIColor(hex: light), dark: UIColor(hex: dark))
    }

    static func dynamicColor(light: UIColor, dark: UIColor) -> Color {
        Color(
            uiColor: UIColor { traits in
                traits.userInterfaceStyle == .dark ? dark : light
            }
        )
    }
}

extension Color {
    init(hex: String) {
        let sanitized = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: sanitized).scanHexInt64(&int)
        let a, r, g, b: UInt64

        switch sanitized.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension UIColor {
    convenience init(hex: String) {
        let sanitized = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: sanitized).scanHexInt64(&int)
        let a, r, g, b: UInt64

        switch sanitized.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }
}
