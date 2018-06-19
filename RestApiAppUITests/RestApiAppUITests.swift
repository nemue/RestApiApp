//
//  RestApiAppUITests.swift
//  RestApiAppUITests
//
//  Created by Nele Müller on 05.06.18.
//  Copyright © 2018 Nele Müller. All rights reserved.
//

import XCTest
@testable import RestApiApp

class RestApiAppUITests: XCTestCase {
    var window: UIWindow!
    var app = XCUIApplication()
        
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        app.launchArguments.append("MockApiCall")
        app.launchArguments.append("MockSpeciesWrapper")
        app.launch()

        self.window = UIWindow()
    }
    
    override func tearDown() {
        self.window = nil
        super.tearDown()
    }
    
    func testMockApiCall() {
        // Given:
        
        let numberOfExpectedRows = 10
        let speciesCells = self.app.tables["SpeciesTableViewIdentifier"].cells
        let speciesArray = saveCellLabelsToStringArray(cells: speciesCells, cellCount: numberOfExpectedRows)
        let textInFirstCell = speciesArray[0]
        let textInLastCell = speciesArray[numberOfExpectedRows - 1]
        
        // Then: 

        XCTAssertNotNil(speciesCells)
        XCTAssertEqual(speciesCells.count, numberOfExpectedRows)
        XCTAssertEqual(textInFirstCell, "Hutt")
        XCTAssertEqual(textInLastCell, "Dug")
    }    
}

// MARK: - Helper Methods

extension RestApiAppUITests {
    func saveCellLabelsToStringArray(cells: XCUIElementQuery, cellCount: Int) -> [String] {
        var i = 0
        var speciesArray = [String]()
        while i < cellCount {
            speciesArray.append(cells.element(boundBy: i).staticTexts.element(boundBy: 0).label)
            i += 1
        }
        
        return speciesArray
    }
}
