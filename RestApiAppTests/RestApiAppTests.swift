//
//  RestApiAppTests.swift
//  RestApiAppTests
//
//  Created by Nele Müller on 08.05.18.
//  Copyright © 2018 Nele Müller. All rights reserved.
//

import XCTest
@testable import RestApiApp

class RestApiAppTests: XCTestCase {
    
    // MARK: Network Manager Tests
    let networkManager = NetworkManager(networking: AlamofireNetworking())
    
    func testMakeUrlHttps() {
        let url = "http://test.com"
        let newUrl = URL.makeHttpsUrlFromString(path: url)
        XCTAssertTrue("https://test.com" == String(describing: newUrl!))
    }
    
    func testInitFromDecoderWithFullSpecies() {
        let filename = "MockSpeciesWrapper"
        let wrapper = initFromDecoderWithFile(name: filename)
        
        XCTAssertNotNil(wrapper)
    }
    
    func testInitFromDecoderWithEmptySpecies() {
        let filename = "MockEmptySpeciesWrapper"
        let wrapper = initFromDecoderWithFile(name: filename)
        
        XCTAssertNotNil(wrapper)
    }
    
    // MARK: - Date Extension Tests
    
    func testDateFromString() {
        let dateString: String = "2018-06-06T12:27:22.877000Z"
        guard let date: Date = Date.fromString(date: dateString) else {
            XCTFail("String could not be converted to Date.")
            return
        }
        
        XCTAssertNotNil(date)
        XCTAssert(type(of: date) == Date.self)
    }
    
    // MARK: - Performance Test
    
    func testPerformanceLoadFirstSpecies() {
        let speciesViewController = SpeciesViewController()
        measure {
            speciesViewController.loadSpeciesFromFirstWrapper()
        }
    }
}

// MARK: - Private Methods

extension RestApiAppTests {
    private func initFromDecoderWithFile(name: String) -> SpeciesWrapper? {
        var data = Data()
        var wrapper = SpeciesWrapper()
        let bundle = Bundle(for: type(of: self))
        
        guard let url = bundle.url(forResource: name, withExtension: "json") else {
            XCTFail("Missing file: \(name)")
            return nil
        }
        
        do{
            data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            wrapper = try decoder.decode(SpeciesWrapper.self, from: data)
        }
        catch {
            XCTFail("Wrapper couldn't be created or decoded: url: \(url)")
        }
        
        return wrapper
    }
}
