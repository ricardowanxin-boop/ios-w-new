import Foundation

enum AppRuntime {
    private static let uiTestingArgument = "-ui-testing"
    private static let useSampleDataEnvironmentKey = "TEMPLATE_UI_TEST_USE_SAMPLE_DATA"

    static var isUITesting: Bool {
        ProcessInfo.processInfo.arguments.contains(uiTestingArgument)
    }

    static var usesSampleDataForUITesting: Bool {
        ProcessInfo.processInfo.environment[useSampleDataEnvironmentKey] != "0"
    }

    static func prepareForUITesting() {
        guard isUITesting else { return }
        SharedDefaults.clearTemplateState()
        SharedDefaults.saveSettings(AppSettings())
        SharedDefaults.saveFeatureFlags(FeatureFlags())

        if usesSampleDataForUITesting {
            SharedDefaults.saveLatestSnapshot(SampleData.snapshot)
        }
    }
}
