import SwiftUI

struct RootView: View {
    private enum RootTab: Hashable {
        case dashboard
        case components
        case settings

        var title: String {
            switch self {
            case .dashboard:
                return "概览"
            case .components:
                return "组件"
            case .settings:
                return "设置"
            }
        }

        var systemImage: String {
            switch self {
            case .dashboard:
                return "rectangle.3.group"
            case .components:
                return "square.grid.2x2"
            case .settings:
                return "gearshape"
            }
        }
    }

    @State private var selectedTab: RootTab = .dashboard
    @State private var rootMessage: String?
    @State private var hasPerformedInitialLoad = false

    @ObservedObject var viewModel: HomeViewModel
    @ObservedObject var settingsStore: AppSettingsStore
    @ObservedObject var featureFlagStore: FeatureFlagStore
    @ObservedObject var appUpdateStore: AppUpdateStore

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                HomeScreen(
                    viewModel: viewModel,
                    settingsStore: settingsStore,
                    onAction: handleQuickAction(_:)
                )
            }
            .tag(RootTab.dashboard)
            .tabItem {
                Label(RootTab.dashboard.title, systemImage: RootTab.dashboard.systemImage)
            }

            if featureFlagStore.flags.showsComponentLab {
                NavigationStack {
                    ComponentsScreen()
                }
                .tag(RootTab.components)
                .tabItem {
                    Label(RootTab.components.title, systemImage: RootTab.components.systemImage)
                }
            }

            NavigationStack {
                SettingsScreen(
                    settingsStore: settingsStore,
                    featureFlagStore: featureFlagStore,
                    appUpdateStore: appUpdateStore,
                    viewModel: viewModel,
                    onMessage: { rootMessage = $0 }
                )
            }
            .tag(RootTab.settings)
            .tabItem {
                Label(RootTab.settings.title, systemImage: RootTab.settings.systemImage)
            }
        }
        .tint(AppTheme.accent)
        .task {
            guard !hasPerformedInitialLoad else { return }
            hasPerformedInitialLoad = true
            await viewModel.loadIfNeeded()

            if settingsStore.settings.autoRefreshOnLaunch {
                await viewModel.refresh(showMessage: false)
            }

            if featureFlagStore.flags.enablesAppUpdateCheck {
                _ = await appUpdateStore.checkForUpdates(trigger: .automatic)
            }
        }
        .onChange(of: viewModel.transientMessage) { _, newValue in
            guard let newValue else { return }
            rootMessage = newValue
            viewModel.transientMessage = nil
        }
        .onChange(of: featureFlagStore.flags.showsComponentLab) { _, isEnabled in
            if !isEnabled && selectedTab == .components {
                selectedTab = .dashboard
            }
        }
        .alert(
            "提示",
            isPresented: Binding(
                get: { rootMessage != nil },
                set: { isPresented in
                    if !isPresented {
                        rootMessage = nil
                    }
                }
            )
        ) {
            Button("知道了", role: .cancel) {
                rootMessage = nil
            }
        } message: {
            Text(rootMessage ?? "")
        }
        .sheet(item: Binding(
            get: { appUpdateStore.presentedUpdate },
            set: { newValue in
                if newValue == nil {
                    appUpdateStore.dismissPresentedUpdate()
                }
            }
        )) { update in
            NavigationStack {
                AppUpdateSheet(update: update) {
                    appUpdateStore.dismissPresentedUpdate()
                }
            }
        }
    }

    private func handleQuickAction(_ action: QuickActionItem) {
        switch action.id {
        case "refresh-data":
            Task {
                await viewModel.refresh()
            }
        case "open-components":
            selectedTab = featureFlagStore.flags.showsComponentLab ? .components : .settings
            rootMessage = action.feedbackMessage
        case "open-settings":
            selectedTab = .settings
            rootMessage = action.feedbackMessage
        default:
            rootMessage = action.feedbackMessage
        }
    }
}
