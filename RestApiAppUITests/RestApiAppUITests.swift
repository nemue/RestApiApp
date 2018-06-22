//
//  RestApiAppUITests.swift
//  RestApiAppUITests
//
//  Created by Nele Müller on 05.06.18.
//  Copyright © 2018 Nele Müller. All rights reserved.
//

import XCTest

class RestApiAppUITests: XCTestCase {
    var window: UIWindow!
    var app = XCUIApplication()
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        self.window = UIWindow()
    }
    
    override func tearDown() {
        self.window = nil
        super.tearDown()
    }
    
    func testMockApiCall() {
        let file = FileEnum.MockData
        self.setupForTestFile(filename: file)
        
        // Given:
        
        let speciesCells = self.getSpeciesTableCells()
        let speciesArray = saveCellLabelsToStringArray(cells: speciesCells)
        let textInFirstCell = speciesArray.first
        let textInLastCell = speciesArray[file.numberOfRows - 1]
        
        // Then: 

        XCTAssertNotNil(speciesCells)
        XCTAssertEqual(speciesCells.count, file.numberOfRows)
        XCTAssertEqual(textInFirstCell, "Hutt")
        XCTAssertEqual(textInLastCell, "Dug")
    }
 
    func testMockApiCallFail() {
        let file = FileEnum.DoesNotExist
        self.setupForTestFile(filename: file)
        
        // Given:
        
        let speciesCells = self.getSpeciesTableCells()
        let alertText = app.alerts.staticTexts["Error"]
        let alertExists = alertText.waitForExistence(timeout: 5)
        
        // Then:
        
        XCTAssert(speciesCells.count == file.numberOfRows)
        XCTAssertTrue(alertExists)
        
        // When:
        
        let alertButton = app.alerts.buttons["OK"]
        alertButton.tap()
        
        // Then:
        
        XCTAssertFalse(alertButton.exists)
    }
}

// MARK: - Helper Methods

extension RestApiAppUITests {
    func setupForTestFile(filename: FileEnum) {
        app.launchEnvironment["TestCall"] = "true"
        app.launchEnvironment["Filename"] = filename.rawValue
        app.launch()
    }
    
    func getSpeciesTableCells() -> XCUIElementQuery {
        return self.app.tables["SpeciesTableViewIdentifier"].cells
    }
    
    func saveCellLabelsToStringArray(cells: XCUIElementQuery) -> [String] {
        var i = 0
        var speciesArray = [String]()
        while i < cells.count {
            speciesArray.append(cells.element(boundBy: i).staticTexts.element(boundBy: 0).label)
            i += 1
        }
        
        return speciesArray
    }
}

enum FileEnum: String {
    case MockData = "MockSpeciesWrapper"
    case DoesNotExist = "FileDoesNotExist"
    
    var numberOfRows: Int {
        switch self {
        case .MockData:
            return 10
        case .DoesNotExist:
            return 0
        }
    }
    
    var textInFirstCell: String {
        switch self {
        case .MockData:
            return "Hut"
        default:
            return ""
        }
    }
    
}
