//
//  RestApiViewUITestsFail.swift
//  RestApiAppUITests
//
//  Created by Nele Müller on 18.06.18.
//  Copyright © 2018 Nele Müller. All rights reserved.
//

import XCTest

class RestApiViewUITestsFail: XCTestCase {
    var window: UIWindow!
    var app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false

        app.launchEnvironment["MockApiCall"] = "true"
        app.launchEnvironment["FileDoesNotExist"] = "true"

        app.launch()

        self.window = UIWindow()
    }
    
    override func tearDown() {
        self.window = nil
        super.tearDown()
    }
    
    
    func testMockApiCallFail() {
        
        // Given: 
        
        let alertText = app.alerts.staticTexts["Error"]
        let alertExists = alertText.waitForExistence(timeout: 5)
        
        // Then:
        
        XCTAssertTrue(alertExists)
        
        // When:
        
        let alertButton = app.alerts.buttons["OK"]
        alertButton.tap()
        
        // Then:
        
        XCTAssertFalse(alertButton.exists)
    }
}
