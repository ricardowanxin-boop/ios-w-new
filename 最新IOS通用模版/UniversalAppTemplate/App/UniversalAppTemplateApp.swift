import SwiftUI
import UIKit

@main
struct UniversalAppTemplateApp: App {
    @StateObject private var settingsStore: AppSettingsStore
    @StateObject private var featureFlagStore: FeatureFlagStore
    @StateObject private var appUpdateStore: AppUpdateStore
    @StateObject private var viewModel: HomeViewModel

    init() {
        AppRuntime.prepareForUITesting()
        Self.configureAppearance()

        let settingsStore = AppSettingsStore()
        let featureFlagStore = FeatureFlagStore()
        let appUpdateStore = AppUpdateStore()
        let viewModel = HomeViewModel()

        _settingsStore = StateObject(wrappedValue: settingsStore)
        _featureFlagStore = StateObject(wrappedValue: featureFlagStore)
        _appUpdateStore = StateObject(wrappedValue: appUpdateStore)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some Scene {
        WindowGroup {
            RootView(
                viewModel: viewModel,
                settingsStore: settingsStore,
                featureFlagStore: featureFlagStore,
                appUpdateStore: appUpdateStore
            )
            .preferredColorScheme(settingsStore.settings.appearance.colorScheme)
        }
    }

    private static func configureAppearance() {
        let accent = UIColor(AppTheme.accent)
        let background = UIColor(AppTheme.surface)
        let border = UIColor(AppTheme.divider)
        let textPrimary = UIColor(AppTheme.textPrimary)
        let textSecondary = UIColor(AppTheme.textSecondary)

        let navigation = UINavigationBarAppearance()
        navigation.configureWithOpaqueBackground()
        navigation.backgroundColor = background
        navigation.shadowColor = border
        navigation.titleTextAttributes = [.foregroundColor: textPrimary]
        navigation.largeTitleTextAttributes = [.foregroundColor: textPrimary]
        UINavigationBar.appearance().standardAppearance = navigation
        UINavigationBar.appearance().scrollEdgeAppearance = navigation
        UINavigationBar.appearance().compactAppearance = navigation

        let tab = UITabBarAppearance()
        tab.configureWithOpaqueBackground()
        tab.backgroundColor = background
        tab.shadowColor = border

        for layout in [tab.stackedLayoutAppearance, tab.inlineLayoutAppearance, tab.compactInlineLayoutAppearance] {
            layout.selected.iconColor = accent
            layout.selected.titleTextAttributes = [.foregroundColor: accent]
            layout.normal.iconColor = textSecondary
            layout.normal.titleTextAttributes = [.foregroundColor: textSecondary]
        }

        UITabBar.appearance().standardAppearance = tab
        UITabBar.appearance().scrollEdgeAppearance = tab

        UISegmentedControl.appearance().selectedSegmentTintColor = accent.withAlphaComponent(0.16)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: textPrimary], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: textSecondary], for: .normal)
    }
}
