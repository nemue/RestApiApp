//
//  RestApiAppAlamofireTests.swift
//  RestApiAppAlamofireTests
//
//  Created by Nele Müller on 08.06.18.
//  Copyright © 2018 Nele Müller. All rights reserved.
//

import XCTest
@testable import RestApiApp
import Alamofire

class RestApiAppAlamofireTests: XCTestCase {
    
    func testAlamofireRequest() {
        let ex = expectation(description: "Alamofire")
        let url = "https://swapi.co/api/species/"
        
        Alamofire.request(url).response{ response in
            XCTAssertNil(response.error, "Error: \(response.error!.localizedDescription)")
            XCTAssertNotNil(response.data, "No data")
            XCTAssertEqual(response.response?.statusCode ?? 0, 200, "Status code not 200")
            
            ex.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }
}
