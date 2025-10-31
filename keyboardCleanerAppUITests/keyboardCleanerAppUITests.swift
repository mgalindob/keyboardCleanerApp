//
//  keyboardCleanerAppUITests.swift
//  keyboardCleanerAppUITests
//
//  Created by Martin Galindo on 10/30/25.
//

import XCTest

final class keyboardCleanerAppUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testAppLaunches() throws {
        // Verify the app launches and key UI elements are present
        let app = XCUIApplication()
        app.launch()
        
        XCTAssertTrue(app.staticTexts["Keyboard Cleaner"].exists, "App title should be visible")
        XCTAssertTrue(app.staticTexts["Keyboard Status:"].exists, "Status label should be visible")
        XCTAssertTrue(app.staticTexts["Instructions:"].exists, "Instructions should be visible")
    }
    
    @MainActor
    func testInitialKeyboardState() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Verify keyboard starts in enabled state
        XCTAssertTrue(app.staticTexts["ENABLED"].exists, "Keyboard should initially be enabled")
        XCTAssertTrue(app.buttons["Disable Keyboard"].exists, "Disable button should be available")
        XCTAssertFalse(app.staticTexts["🧽 Safe to clean your keyboard!"].exists, "Clean message should not show initially")
    }
    
    @MainActor
    func testDisableButtonExists() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Test that the main disable button is present and can be interacted with
        let disableButton = app.buttons["Disable Keyboard"]
        XCTAssertTrue(disableButton.exists, "Disable keyboard button should exist")
        XCTAssertTrue(disableButton.isEnabled, "Disable keyboard button should be enabled")
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
