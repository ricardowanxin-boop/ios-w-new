import XCTest

final class UniversalAppTemplateUITests: XCTestCase {
    private let timeout: TimeInterval = 12

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunchesDashboardAndCanSwitchTabs() throws {
        let app = launchApp()

        XCTAssertTrue(app.otherElements["dashboard-hero-card"].waitForExistence(timeout: timeout))
        XCTAssertTrue(app.tabBars.buttons["概览"].exists)

        app.tabBars.buttons["组件"].tap()
        XCTAssertTrue(app.staticTexts["模板组件库"].waitForExistence(timeout: timeout))

        app.tabBars.buttons["设置"].tap()
        XCTAssertTrue(app.buttons["settings-check-update-button"].waitForExistence(timeout: timeout))

        app.tabBars.buttons["概览"].tap()
        XCTAssertTrue(app.otherElements["dashboard-hero-card"].waitForExistence(timeout: timeout))
    }

    func testCanTriggerQuickActionAndResetTemplateData() throws {
        let app = launchApp()

        let quickAction = app.buttons["quick-action-open-components"]
        XCTAssertTrue(quickAction.waitForExistence(timeout: timeout))
        quickAction.tap()
        XCTAssertTrue(app.staticTexts["模板组件库"].waitForExistence(timeout: timeout))

        app.tabBars.buttons["设置"].tap()
        let resetButton = app.buttons["settings-reset-template-data"]
        XCTAssertTrue(resetButton.waitForExistence(timeout: timeout))
        resetButton.tap()

        XCTAssertTrue(app.alerts["提示"].buttons["知道了"].waitForExistence(timeout: timeout))
        app.alerts["提示"].buttons["知道了"].tap()
    }

    private func launchApp() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments.append("-ui-testing")
        app.launch()
        return app
    }
}
